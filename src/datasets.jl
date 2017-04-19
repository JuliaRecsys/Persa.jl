using DataFrames

abstract CFDatasetAbstract;

immutable RatingPreferences{T}
  possibles::Array{T, 1}
  min::T
  max::T
end

immutable TimeCFDataset <: CFDatasetAbstract
  file::DataFrame
  users::Int
  items::Int
  preferences::RatingPreferences
end

immutable CFDataset <: CFDatasetAbstract
  file::DataFrame
  users::Int
  items::Int
  preferences::RatingPreferences
end

RatingPreferences{T<:Real}(possibles::Array{T, 1}) = RatingPreferences(sort(possibles), minimum(possibles), maximum(possibles))
Base.minimum(preferences::RatingPreferences) = preferences.min
Base.maximum(preferences::RatingPreferences) = preferences.max
Base.size(preferences::RatingPreferences) = length(preferences.possibles)
Base.eltype(preferences::RatingPreferences) = eltype(preferences.possibles)

function Base.round{T}(rating::T, preferences::RatingPreferences{T})
  ratings = sort(preferences.possibles)

  m = abs(rating .- ratings)

  return ratings[find(r->r == minimum(m), m)[end]]
end

Base.round(rating::Float64, preferences::RatingPreferences{Int}) = Base.round(convert(Int, round(rating)), preferences)
Base.round{T}(rating, preferences::RatingPreferences{T}) = Base.round(convert(T, rating), preferences)

recommendation(preferences::RatingPreferences) = maximum(preferences) - round(1/3 * (maximum(preferences) -  minimum(preferences)))
recommendation(ds::CFDatasetAbstract) = maximum(ds.preferences) - round(1/3 * (maximum(ds.preferences) -  minimum(ds.preferences)))

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

Base.length{T<:CFDatasetAbstract}(dataset::T) = size(dataset.file)[1]

sparsity(dataset::CFDatasetAbstract) = length(dataset) / (dataset.users * dataset.items)

Base.copy{T<:CFDatasetAbstract}(dataset::T) = T(deepcopy(dataset.file), dataset.users, dataset.items, dataset.preferences)

Base.length(dataset::CFDatasetAbstract) = size(dataset.file)[1]

getMatrix(dataset::CFDatasetAbstract) = sparse(dataset.file[:user], dataset.file[:item], dataset.file[:rating], dataset.users, dataset.items)

Base.getindex(ds::CFDatasetAbstract, idx) = (ds.file[:user][idx], ds.file[:item][idx], ds.file[:rating][idx])
Base.getindex(ds::TimeCFDataset, idx) = (ds.file[:user][idx], ds.file[:item][idx], ds.file[:rating][idx], ds.file[:timestamp][idx])

Base.start(ds::CFDatasetAbstract) = 1
Base.done(ds::CFDatasetAbstract, state) = state > length(ds)
Base.next(ds::CFDatasetAbstract, state) = ds.file[state], state + 1

Base.next(ds::TimeCFDataset, state) = ds.file[state], state + 1
