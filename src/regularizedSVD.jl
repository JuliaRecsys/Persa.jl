mutable struct RegularizedSVD <: CFModel
  P::Array
  Q::Array
  preferences::RatingPreferences
end

function RegularizedSVD{T<:CFDatasetAbstract}(dataset::T, features::Int)
  (result, -) = svds(getmatrix(dataset), nsv = features)
  U = result.U
  V = result.Vt

  return RegularizedSVD(U[:,1:features], V[:,1:features], dataset.preferences);
end

predict(model::RegularizedSVD, user::Int, item::Int) = correct(model.P[user, :] ⋅ model.Q[item, :], model.preferences)

canpredict(model::RegularizedSVD, user::Int, item::Int) = true

function train!{T<:CFDatasetAbstract}(model::RegularizedSVD,
                dataset::T;
                lrate = 0.001,
                lambda = 0.02,
                min_epochs=0,
                max_epochs=100)::ModelStatistic

  features = size(model.P)[2];

  matrix = getmatrix(dataset)

  (users_idx, items_idx) = ind2sub(size(matrix), find(r-> r != 0, matrix));

  idx_length = size(users_idx)[1]

  last_error = Inf

  for epoch=1:max_epochs
    mix = shuffle(1:length(users_idx))
    users_idx = users_idx[mix]
    items_idx = items_idx[mix]

    for i=1:idx_length
      error = matrix[users_idx[i], items_idx[i]] - predict(model, users_idx[i], items_idx[i])

      model.P[users_idx[i],:] = model.P[users_idx[i],:] + lrate * (error * model.Q[items_idx[i],:] - lambda * model.P[users_idx[i],:]);
      model.Q[items_idx[i],:] = model.Q[items_idx[i],:] + lrate * (error * model.P[users_idx[i],:] - lambda * model.Q[items_idx[i],:]);
    end

    error = 0

    for i=1:idx_length
      error += (matrix[users_idx[i], items_idx[i]] - predict(model, users_idx[i], items_idx[i])) ^ 2
      error += lambda * (norm(model.P[users_idx[i],:]) ^ 2 + norm(model.Q[items_idx[i],:]) ^ 2)
    end

    if epoch > min_epochs && error > last_error
      break
    end
  end

  return model;
end
