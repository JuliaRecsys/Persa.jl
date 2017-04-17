abstract CFModel;

function predict{T <: CFModel}(model::T, data::Array)
  [ canPredict(model, data[i,1], data[i,2]) ? predict(model, data[i,1], data[i,2]): NaN for i=1:size(data)[1]]
end

predict{T <: CFModel}(model::T, dataset::CFDatasetAbstract) = predict(model, dataset.file)

predict{T <: CFModel}(model::T, data::DataFrame) = predict(model, Array(data))

immutable ModelStatistic
  e::Dict{String, Any}
end

ModelStatistic() = ModelStatistic(Dict{String, Any}())

push!(statistic::ModelStatistic, key::String, value::Any) = statistic.e[key] = value
