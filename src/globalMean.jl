type GlobalMean <: CFModel
  μ::Float64
end

GlobalMean{T<:CFDatasetAbstract}(dataset::T) = GlobalMean(mean(dataset))

train!{T<:CFDatasetAbstract}(model::GlobalMean, dataset::T)::ModelStatistic = model

predict(model::GlobalMean, user::Int, item::Int) = model.μ

canPredict(model::GlobalMean, user::Int, item::Int) = true
