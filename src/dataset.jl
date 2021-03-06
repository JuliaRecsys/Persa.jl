import DataFrames.DataFrames
using SparseArrays
using Statistics
using ArgCheck

abstract type AbstractDataset{T <: Number}
end

struct Dataset{T <: Number} <: AbstractDataset{T}
    ratings::SparseMatrixCSC{AbstractRating{T}, Int}
    preference::Preference{T}
    users::Int
    items::Int
end

sample(dataset::Dataset, index::Array) = Persa.Dataset(dataset[index], dataset.users, dataset.items, dataset.preference)

Base.string(x::Dataset) = string("""Collaborative Filtering Dataset
                                    - # users: $(users(x))
                                    - # items: $(items(x))
                                    - # ratings: $(length(x))
                                    - Ratings Preference: $(x.preference)
                                    """)
Base.print(io::IO, x::Dataset) = print(io, string(x))
Base.show(io::IO, x::Dataset) = print(io, x)

struct UserPreference{T}
    user::Int
    item::Int
    rating::AbstractRating{T}
end

Base.string(x::UserPreference) = string("(user: ", user(x), ", item: ", item(x), ", rating: ", rating(x), ")")
Base.print(io::IO, x::UserPreference) = print(io, string(x))
Base.show(io::IO, x::UserPreference) = print(io, x)

user(x::UserPreference) = x.user
item(x::UserPreference) = x.item
rating(x::UserPreference) = x.rating

Base.iterate(p::UserPreference, state=1) = length(fieldnames(typeof(p))) < state ? nothing : (p[state], state+1)

Base.getindex(p::UserPreference{T}, i::Int) where T = length(fieldnames(typeof(p))) < i ? nothing : getfield(p, i)

function Dataset(df::DataFrames.DataFrame, users::Int, items::Int)
    columns = propertynames(df)
    @argcheck in(:user, columns)
    @argcheck in(:item, columns)
    @argcheck in(:rating, columns)

    @argcheck users >= maximum(df[!, :user])
    @argcheck items >= maximum(df[!, :item])

    preference = Preference([df[!, :rating]...])

    ratings = convert([df[!, :rating]...], preference)

    matriz = sparse([df[!, :user]...], [df[!, :item]...], ratings, users, items, rerating)

    return Dataset(matriz, preference, users, items)
end

function Dataset(userprefs::Vector{UserPreference{T}}, users::Int, items::Int, preference::Preference) where T
    userslist = Vector{Int}(undef, length(userprefs))
    itemslist = Vector{Int}(undef, length(userprefs))
    ratingslist = Vector{AbstractRating{T}}(undef, length(userprefs))

    for i = 1:length(userprefs)
        (u, v, r) = userprefs[i]
        userslist[i] = u
        itemslist[i] = v
        ratingslist[i] = r
    end

    matriz = sparse(userslist, itemslist, ratingslist, users, items)

    return Dataset(matriz, preference, users, items)
end

Dataset(df::DataFrames.DataFrame) = Dataset(df, maximum(df[!, :user]), maximum(df[!, :item]))

users(dataset::AbstractDataset) = dataset.users
items(dataset::AbstractDataset) = dataset.items

Base.size(dataset::AbstractDataset) = (users(dataset), items(dataset))
Base.length(dataset::AbstractDataset) = length(nonzeros(dataset.ratings))

function Base.Array(dataset::Dataset{T})::Matrix{Union{Missing, T}} where T <: Number
    matrix = Array{Union{Missing, T}}(missing, Persa.users(dataset), Persa.items(dataset))

    users = rowvals(dataset.ratings)
    ratings = nonzeros(dataset.ratings)
    for item = 1:items(dataset)
       for j in nzrange(dataset.ratings, item)
          user = users[j]
          rating = ratings[j]
          matrix[user, item] = value(rating)
       end
    end

    return matrix
end

function Base.getindex(dataset::AbstractDataset, user::Int, item::Int)::AbstractRating
    @argcheck user >= 0 && user <= users(dataset)
    @argcheck item >= 0 && item <= items(dataset)

    dataset.ratings[user, item]
end

function Base.getindex(dataset::AbstractDataset{T}, i::Int)::UserPreference{T} where T
    if i > length(dataset)
        throw(ArgumentError("index must satisfy 1 <= i <= length(dataset)"))
    end

    users = rowvals(dataset.ratings)
    ratings = nonzeros(dataset.ratings)

    for item = 1:items(dataset)
        if i in nzrange(dataset.ratings, item)
            user = users[i]
            rating = ratings[i]

            return UserPreference{T}(user, item, rating)
        end
    end
end

function Base.getindex(dataset::AbstractDataset{T}, user::Int, c::Colon) where T
    elements = Persa.UserPreference{T}[]

    for i=1:items(dataset)
        value = dataset[user, i]
        if !isnan(value)
            push!(elements, UserPreference(user, i, value))
        end
    end

    return elements
end

function Base.getindex(dataset::AbstractDataset{T}, user::Int, index::UnitRange{Int}) where T
    elements = Persa.UserPreference{T}[]

    for i=1:length(index)
        value = dataset[user, index[i]]
        if !isnan(value)
            push!(elements, UserPreference(user, index[i], value))
        end
    end

    return elements
end

function Base.getindex(dataset::AbstractDataset{T}, c::Colon, item::Int) where T
    elements = Persa.UserPreference{T}[]

    for i=1:users(dataset)
        value = dataset[i, item]
        if !isnan(value)
            push!(elements, UserPreference(i, item, value))
        end
    end

    return elements
end

function Base.getindex(dataset::AbstractDataset{T}, index::UnitRange{Int}, item::Int) where T
    elements = Persa.UserPreference{T}[]

    for i=1:length(index)
        value = dataset[index[i], item]
        if !isnan(value)
            push!(elements, UserPreference(index[i], item, value))
        end
    end

    return elements
end

function Base.getindex(dataset::AbstractDataset{T}, index::Vector{Int}) where T
    elements = Vector{UserPreference{T}}(undef, length(index))

    for i = 1:length(index)
        elements[i] = dataset[index[i]]
    end

    return elements
end

function Base.getindex(dataset::AbstractDataset{T}, index::UnitRange{Int}) where T
    elements = Vector{UserPreference{T}}(undef, length(index))
    j = 1

    for i in index
        elements[j] = dataset[i]
        j += 1
    end

    return elements
end

function Base.getindex(dataset::AbstractDataset{T}, users::UnitRange{Int}, items::UnitRange{Int}) where T
    elements = UserPreference{T}[]

    for user in users, item in items
        value = dataset[user, item]
        if !isnan(value)
            push!(elements, UserPreference(user, item, value))
        end
    end

    return elements
end

Base.getindex(dataset::AbstractDataset, c1::Colon, c2::Colon) = dataset[1:end, 1:end]

Base.getindex(dataset::AbstractDataset, c::Colon) = dataset[1:length(dataset)]

Base.iterate(dataset::AbstractDataset, state = 1) = state > length(dataset) ? nothing : (dataset[state], state+1)

Base.lastindex(dataset::AbstractDataset, d::Int) = d == 1 ? users(dataset) : items(dataset)

function Statistics.mean(dataset::AbstractDataset)
    μ = 0
    total = 0
    for (u, v, r) in dataset
        if !isnan(r)
            μ += r
            total += 1
        end
    end
    return μ ./ total
end
