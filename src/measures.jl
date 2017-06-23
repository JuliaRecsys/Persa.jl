using MLBase

#Mean absolute error (MAE)
mae(labels, predicted) = mean(abs(predicted[find(r -> r > 0, predicted),1] - labels[find(r -> r > 0, predicted),1]));

#Root mean squared error (RMSE)
function rmse(labels, predicted)
  s = 0.0

  A = predicted[find(r -> r > 0, predicted),1] - labels[find(r -> r > 0, predicted),1];

  for a in A
    s += a*a
  end
  return sqrt(s / length(A))
end

#Coverage
coverage(predicted) = length(find(r-> r > 0, predicted[:,1])) ./ length(predicted[:,1]);

abstract type CFMetrics

struct AccuracyMeasures <: CFMetrics
  mae::Float64
  rmse::Float64
  coverage::Float64
end

struct DecisionMetrics <: CFMetrics
  roc::ROCNums
end

AccuracyMeasures(labels::Array, predict::Array) = AccuracyMeasures(mae(labels, predict), rmse(labels, predict), coverage(predict))

DecisionMetrics(labels::Array, predict::Array, threshold::Number) = DecisionMetrics(MLBase.roc(labels .>= threshold, predict .>= threshold))

struct ResultPredict <: CFMetrics
  accuracy::AccuracyMeasures
  decision::DecisionMetrics
end

function ResultPredict(model::CFModel, data_test::Array, threshold::Number)
  predicted = predict(model, data_test)
  acc = AccuracyMeasures(data_test[:,3], predicted)
  dec = DecisionMetrics(data_test[:,3], predicted, threshold)

  return ResultPredict(acc, dec)
end

function AccuracyMeasures(model::CFModel, data_test::Array)
  predicted = predict(model, data_test)

  return AccuracyMeasures(data_test[:,3], predicted)
end

aval{T <: CFModel}(model::T, data_test::Array) = AccuracyMeasures(model, data_test)
aval{T <: CFModel}(model::T, data_test::Array, threshold::Number) = ResultPredict(model, data_test, threshold)

function Base.print(result::ResultPredict)
  print(result.accuracy)
  print(result.decision)
end

DataFrame(result::ResultPredict) = hcat(DataFrame(result.accuracy), DataFrame(result.decision))

function Base.print(result::AccuracyMeasures)
  println("MAE - $(result.mae)")
  println("RMSE - $(result.rmse)")
  println("Coverage - $(result.coverage)")
end

function DataFrame(result::AccuracyMeasures)
  df = DataFrame()
  df[:mae] = result.mae
  df[:rmse] = result.rmse
  df[:coverage] = result.coverage
  return df
end

function Base.print(result::DecisionMetrics)
  println("Recall - $(recall(result.roc))")
  println("Precision - $(precision(result.roc))")
  println("F1-Score - $(f1score(result.roc))")
end

function DataFrame(result::DecisionMetrics)
  df = DataFrame()
  df[:recall] = recall(result.roc)
  df[:precision] = precision(result.roc)
  df[:f1score] = f1score(result.roc)
  return df
end

function DataFrame(result::CFMetrics...)
  df = DataFrame()
  for i=1:length(result)
    df = hcat(df, DataFrame(result[i]))
  end

  return df
end
