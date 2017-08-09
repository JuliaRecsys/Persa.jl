using DataFrames

abstract type CFDatasetAbstract

end

struct RatingPreferences{T}
  possibles::Array{T, 1}
  min::T
  max::T
end

struct TimeCFDataset <: CFDatasetAbstract
  file::DataFrame
  users::Int
  items::Int
  preferences::RatingPreferences
end

struct CFDataset <: CFDatasetAbstract
  file::DataFrame
  users::Int
  items::Int
  preferences::RatingPreferences
end

RatingPreferences{T<:Real}(possibles::Array{T, 1}) = RatingPreferences(sort(possibles), minimum(possibles), maximum(possibles))

"""
    minimum(preferences::RatingPreferences)

Return lower value of rating preferences.
"""
Base.minimum(preferences::RatingPreferences) = preferences.min

"""
    maximum(preferences::RatingPreferences)

Return highest value of rating preferences.
"""
Base.maximum(preferences::RatingPreferences) = preferences.max

"""
    size(preferences::RatingPreferences)

Return number of elements contained in the rating preferences.
"""
Base.size(preferences::RatingPreferences) = length(preferences.possibles)

"""
    eltype(preferences::RatingPreferences)

Return rating type.
"""
Base.eltype(preferences::RatingPreferences) = eltype(preferences.possibles)

possiblesratings(preferences::RatingPreferences) = preferences.possibles
possiblesratings(ds::CFDatasetAbstract) = possiblesratings(ds.preferences)

"""
    round{T}(rating::T, preferences::RatingPreferences{T})

Returns the nearest integral value of the rating preferences.
"""
function Base.round{T}(rating::T, preferences::RatingPreferences{T})
  ratings = sort(preferences.possibles)

  m = abs.(rating .- ratings)

  return ratings[find(r->r == minimum(m), m)[end]]
end

Base.round(rating::Float64, preferences::RatingPreferences{Int}) = Base.round(convert(Int, round(rating)), preferences)
Base.round{T}(rating, preferences::RatingPreferences{T}) = Base.round(convert(T, rating), preferences)

recommendation(preferences::RatingPreferences) = maximum(preferences) - round(1/3 * (maximum(preferences) -  minimum(preferences)))
recommendation(ds::CFDatasetAbstract) = recommendation(ds.preferences)

"""
    correct(rating::Real, preferences::RatingPreferences)

Returns the correct value preserving the interval of rating
preferences.
"""
function correct(rating::Real, preferences::RatingPreferences)
  if rating > maximum(preferences)
    return maximum(preferences)
  elseif rating < minimum(preferences)
    return minimum(preferences)
  end
  return rating
end

function Dataset(df::DataFrame)::CFDatasetAbstract
  @assert in(:user, names(df))
  @assert in(:item, names(df))
  @assert in(:rating, names(df))

  if in(:timestamp, names(df))
    return TimeCFDataset(df, maximum(df[:user]), maximum(df[:item]), RatingPreferences(convert(Array, unique(df[:rating]))))
  else
    return CFDataset(df, maximum(df[:user]), maximum(df[:item]), RatingPreferences(convert(Array, unique(df[:rating]))))
  end
end

function createdummydataset()::CFDatasetAbstract
  df = DataFrame()
  df[:user] = [1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 3, 3, 3, 3, 4, 4, 4, 4, 4, 5, 5, 5, 5, 5, 5, 6, 6, 6, 6, 6, 7, 7, 7]
  df[:item] = [1, 2, 3, 4, 5, 6, 1, 2, 3, 4, 5, 6, 1, 2, 3, 4, 2, 3, 4, 5, 6, 1, 2, 3, 4, 5, 6, 1, 2, 4, 5, 6, 2, 4, 5]
  df[:rating] = [2.5, 3.5, 3.0, 3.5, 2.5, 3.0, 3, 3.5, 1.5, 5, 3, 3.5, 2.5, 3.0, 3.5, 4.0, 3.5, 3.0, 4.0, 2.5, 4.5, 3.0, 4.0, 2.0, 3.0, 2.0, 3.0, 3.0, 4.0, 5.0, 3.5, 3.0, 4.5, 4.0, 1.0]
  return Dataset(df)
end

"""
    length(dataset::CFDatasetAbstract)

Returns the number of ratings in the database.
"""
Base.length(dataset::CFDatasetAbstract) = size(dataset.file)[1]

sparsity(dataset::CFDatasetAbstract) = length(dataset) / (dataset.users * dataset.items)

Base.copy{T<:CFDatasetAbstract}(dataset::T) = T(deepcopy(dataset.file), dataset.users, dataset.items, dataset.preferences)

getmatrix(dataset::CFDatasetAbstract) = sparse(dataset.file[:user], dataset.file[:item], dataset.file[:rating], dataset.users, dataset.items)

@deprecate getMatrix(dataset::CFDatasetAbstract) getmatrix(dataset)

function Base.getindex(ds::CFDatasetAbstract, idx::Int, c::Colon)
  return ds.file[find(r->r == idx, ds.file[:user]), [:item, :rating]]
end

function Base.getindex(ds::CFDatasetAbstract, c::Colon, idx::Int)
  return ds.file[find(r->r == idx, ds.file[:item]), [:user, :rating]]
end

Base.getindex(ds::CFDatasetAbstract, idx) = (ds.file[:user][idx], ds.file[:item][idx], ds.file[:rating][idx])
Base.getindex(ds::TimeCFDataset, idx) = (ds.file[:user][idx], ds.file[:item][idx], ds.file[:rating][idx], ds.file[:timestamp][idx])

Base.start(ds::CFDatasetAbstract) = 1
Base.done(ds::CFDatasetAbstract, state) = state > length(ds)
Base.next(ds::CFDatasetAbstract, state) = ds[state], state + 1

Base.next(ds::TimeCFDataset, state) = ds[state], state + 1
