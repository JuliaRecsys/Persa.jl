using Base: depwarn

abstract type CFModel

end

function predict{T <: CFModel}(model::T, data::Array)
  [ canpredict(model, data[i,1], data[i,2]) ? predict(model, data[i,1], data[i,2]): NaN for i=1:size(data)[1]]
end

predict{T <: CFModel}(model::T, dataset::CFDatasetAbstract) = predict(model, dataset.file)

predict{T <: CFModel}(model::T, data::DataFrame) = predict(model, Array(data))

function canpredict(model::CFModel, user::Int, item::Int)
    depwarn("canPredict is deprecated, use canPredict instead.", :canPredict)
    canPredict(model, user, item)
end

@deprecate canPredict(model::CFModel, user::Int, item::Int) canpredict(model, user, item)
