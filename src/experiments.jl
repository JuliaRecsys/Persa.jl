using DataFrames

immutable Parameter
  name::String
  value::Any
end

immutable ParameterList
  parameters::Array{Parameter}
end

function ParameterList(data...)
  pa = ParameterList(Array{Parameter}(0))

  for i=1:2:length(data)
    Base.push!(pa.parameters, Parameter(data[i], data[i+1]))
  end

  return pa
end

Base.length(pl::ParameterList) = length(pl.parameters)

immutable ExperimentResult{T <: CFMetrics}
  result::T
  parameters::ParameterList
end

ExperimentResult{T <: CFMetrics}(result::T, data...) = ExperimentResult(result, ParameterList(data...))

immutable Experiments{T <: CFMetrics}
  e::Array{ExperimentResult{T}}
end

Experiments(T::Type) = Experiments(Array{ExperimentResult{T}}(0))

Base.length(results::Experiments) = length(results.e)

Base.getindex(results::Experiments, x::Int) = results.e[x]

Base.getindex(results::Experiments, x::Array) = results.e[x]

Base.getindex(results::Experiments, ::Colon) = results.e[:]

function push!(experiments::Experiments, er::ExperimentResult)
  push!(experiments.e, er)

  return experiments
end

push!{T <: CFMetrics}(experiments::Experiments, result::T, data...) = Base.push!(experiments.e, ExperimentResult(result, data...))

function DataFrame(result::ExperimentResult)
  df = DataFrame()
  for i=1:length(result.parameters)
    df[Symbol(result.parameters.parameters[i].name)] = result.parameters.parameters[i].value
  end

  return hcat(df, DataFrame(result.result))
end

function DataFrame(result::Experiments)
  df = DataFrame(result[1])

  for i=2:length(result)
    append!(df, DataFrame(result[i]))
  end

  return df
end
