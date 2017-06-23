using Persa
using DatasetsCF
using Surprise

ds = DatasetsCF.MovieLens()

holdout = Persa.HoldOut(ds, 0.9)

(ds_train, ds_test) = Persa.get(holdout)

function createmodel(dataset::Persa.CFDatasetAbstract, features, lrate, lamda)
  model = Surprise.IRSVD(dataset; features = features, lrate = lrate, lambda = lambda)

  Persa.train!(model, dataset)

  return model
end

best_model, best_cfg, best_score = Persa.modeltune(ds_train, createmodel,
                                                ("features", [2 3 5]),
                                                ("lrate", [0.1 0.01]),
                                                ("lambda", [0.1 0.01]))

(features, lrate, lambda) = best_cfg
