using DataFrames
using SparseArrays
using Statistics

struct Dataset{T <: Number}
    ratings::SparseMatrixCSC{AbstractRating{T}, Int}
    preference::Preference{T}
    users::Int
    items::Int
end

struct UserPreference
    user::Int
    item::Int
    rating::AbstractRating
end

user(x::UserPreference) = x.user
item(x::UserPreference) = x.item
rating(x::UserPreference) = x.rating

Base.iterate(p::UserPreference, state=1) = length(fieldnames(typeof(p))) < state ? nothing : (getfield(p, state), state+1)

function Dataset(df::DataFrame, users::Int, items::Int)
    @assert in(:user, names(df))
    @assert in(:item, names(df))
    @assert in(:rating, names(df))

    if users < maximum(df[:user]) || items < maximum(df[:item])
        throw(ArgumentError("users or items must satisfy maximum[df[:k]] >= k"))
    end

    preference = Preference(df[:rating])

    ratings = convert(df[:rating], preference)

    matriz = sparse(df[:user], df[:item], ratings, users, items)

    return Dataset(matriz, preference, users, items)
end

Dataset(df::DataFrame) = Dataset(df, maximum(df[:user]), maximum(df[:item]))

users(dataset::Dataset) = dataset.users
items(dataset::Dataset) = dataset.items

Base.size(dataset::Dataset) = (users(dataset), items(dataset))
Base.length(dataset::Dataset) = length(nonzeros(dataset.ratings))

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

checkuser(dataset::Dataset, user::Int) = (user >= 0 && user <= users(dataset)) ? user : error("invalid user id ($user)")
checkitem(dataset::Dataset, item::Int) = (item >= 0 && item <= items(dataset)) ? item : error("invalid item id ($item)")

function Base.getindex(dataset::Dataset, user::Int, item::Int)::AbstractRating
    checkuser(dataset, user)
    checkitem(dataset, item)

    dataset.ratings[user, item]
end

function Base.getindex(dataset::Dataset, i::Int)::UserPreference
    if i > length(dataset)
        throw(ArgumentError("index must satisfy 1 <= i <= length(dataset)"))
    end

    users = rowvals(dataset.ratings)
    ratings = nonzeros(dataset.ratings)

    for item = 1:items(dataset)
        if i in nzrange(dataset.ratings, item)
            user = users[i]
            rating = ratings[i]

            return UserPreference(user, item, rating)
        end
    end
end

function Base.getindex(dataset::Dataset, user::Int, c::Colon)
    elements = collect(dataset.ratings[user, :])
    return [(idx, elements[idx]) for idx in findall(!isnan, elements)]
end

function Base.getindex(dataset::Dataset, c::Colon, item::Int)
    elements = collect(dataset.ratings[:, item])
    return [(idx, elements[idx]) for idx in findall(!isnan, elements)]
end

function Base.getindex(dataset::Dataset, index::Vector{Int})
    elements = Vector{UserPreference}(undef, length(index))

    for i = 1:length(index)
        elements[i] = dataset[index[i]]
    end

    return elements
end

Base.iterate(dataset::Dataset, state = 1) = state > length(dataset) ? nothing : (dataset[state], state+1)

function Statistics.mean(dataset::Dataset)
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
