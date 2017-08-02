mutable struct ImprovedRegularizedSVD <: CFModel
  μ::Float64
  bias_user::Array
  bias_item::Array
  P::Array
  Q::Array
  preferences::RatingPreferences
end

function ImprovedRegularizedSVD(dataset::CFDatasetAbstract, features::Int)
  (result, -) = svds(getMatrix(dataset), nsv = features)
  U = result.U
  V = result.Vt

  return ImprovedRegularizedSVD(mean(dataset), zeros(dataset.users, 1), zeros(dataset.items, 1), U[:,1:features], V[:,1:features], dataset.preferences);
end

predict(model::ImprovedRegularizedSVD, user::Int, item::Int) = correct(model.μ + model.bias_user[user] + model.bias_item[item] + model.P[user, :] ⋅ model.Q[item, :], model.preferences)

canpredict(model::ImprovedRegularizedSVD, user::Int, item::Int) = true

function update!{T<:CFDatasetAbstract}(model::ImprovedRegularizedSVD, dataset::T, lrate::Float64, lambda::Float64)

  idx = shuffle(1:length(dataset))

  r_predicted = predict(model, dataset)

  for i=1:size(idx)[1]
    u = dataset.file[idx[i], 1]
    v = dataset.file[idx[i], 2]
    r = dataset.file[idx[i], 3]

    error = r - r_predicted[idx[i]]

    model.bias_user[u,:] += lrate * (error - lambda * model.bias_user[u,:]);
    model.bias_item[v,:] += lrate * (error - lambda * model.bias_item[v,:]);


    P = model.P[u,:];

    model.P[u,:] += lrate * (error * model.Q[v,:] - lambda * model.P[u,:]);
    model.Q[v,:] += lrate * (error * P - lambda * model.Q[v,:]);
  end
end

function error{T<:CFDatasetAbstract}(model::ImprovedRegularizedSVD, dataset::T, lambda::Float64)
  error = 0

  for i=1:length(dataset)
    error += (dataset.file[i,3] - predict(model, dataset.file[i,1], dataset.file[i,2])) ^ 2
    error += lambda * (model.bias_user[dataset.file[i,1]] ^ 2 + model.bias_item[dataset.file[i,2]] ^ 2)
    error += lambda * (norm(model.P[dataset.file[i,1],:]) ^ 2 + norm(model.Q[dataset.file[i,2],:]) ^ 2)
  end

  return error
end

function train!{T<:CFDatasetAbstract}(model::ImprovedRegularizedSVD,
                dataset::T;
                lrate = 0.001,
                lambda = 0.02,
                min_epochs=0,
                max_epochs=1000)::ModelStatistic

  holdout = Persa.HoldOut(dataset, 0.9)

  (ds_v_train, ds_v_test) = Persa.get(holdout)

  errors_function = []
  errors_val = []

  error_limit_stop = 10
  error_count_stop = 0

  val_limit_stop = 10
  val_count_stop = 0

  snapshot = model

  for epoch=1:max_epochs
    update!(model, ds_v_train, lrate, lambda)

    Base.push!(errors_function, error(model, ds_v_train, lambda))
    Base.push!(errors_val, Persa.aval(model, ds_v_test).rmse)

    if epoch > min_epochs && epoch >= 2
      if errors_function[end] > errors_function[end-1]
        error_count_stop += 1
      else
        error_count_stop = 0
      end

      if errors_val[end] > errors_val[end-1]
        val_count_stop += 1
      else
        val_count_stop = 0
      end

      if error_count_stop == 1 || val_count_stop == 1
        snapshot = deepcopy(model)
      end

      if abs(errors_val[end] - errors_val[end-1]) <= 1E-5 || abs(errors_function[end] - errors_function[end-1]) <= 1E-5
        if error_count_stop >= 1 || val_count_stop >= 1
          model = snapshot
        end
        break
      end

      if error_count_stop >= error_limit_stop || val_count_stop >= val_limit_stop
        model = snapshot
        break
      end
    end
  end

  statistic = Persa.ModelStatistic()
  push!(statistic, "error", errors_function)
  push!(statistic, "validation", errors_val)

  return statistic
end
