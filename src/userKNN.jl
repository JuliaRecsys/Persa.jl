type UserKNN <: CFModel
  b::Array{Float64,1}
  w::Similarity
  k::Int
  preferences::RatingPreferences
end

function UserKNN{T<:CFDatasetAbstract}(dataset::T, k::Int; α = 10)
  return UserKNN(shrunkUserMean(dataset, α), Similarity(dataset, k), k, dataset.preferences)
end

train!{T<:CFDatasetAbstract}(model::UserKNN, dataset::T; α::Int = 10)::ModelStatistic = ModelStatistic()

function predict(model::UserKNN, user::Int, item::Int)
  neighbours = getWeights(model.w, user, item)

  if length(neighbours) < model.k
    return NaN
  end

  sort!(neighbours, by=x->(x[2]), rev=true)

  r, total = 0, 0

  for i=1:model.k
    r += (model.w.matrix[neighbours[i][1], item] - model.b[neighbours[i][1]]) .* neighbours[i][2]
    total += abs(neighbours[i][2])
  end

  return correct((r ./ total) + model.b[user], model.preferences)
end

function canPredict(model::UserKNN, user::Int, item::Int)
  neighbours = getWeights(model.w, user, item)

  if length(neighbours) >= model.k
    return true
  else
    return false
  end
end
