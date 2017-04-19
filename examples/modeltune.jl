reload("Persa")

cf = Persa

ds = cf.CiaoDVD()

holdout = cf.HoldOut(ds, 0.9)

(ds_train, ds_test) = cf.get(holdout)

function createmodel(dataset::cf.CFDatasetAbstract, features, lrate, lamda)
  model = cf.SurpriseIRSVD(dataset; features = features)

  cf.train!(model, dataset)

  return model
end

best_model, best_cfg, best_score = cf.modeltune(ds_train, createmodel,
                                                ("features", [2 3 5]),
                                                ("lrate", [0.1 0.01]),
                                                ("lambda", [0.1 0.01]))

(features, lrate, lambda) = best_cfg


model = cf.SurpriseIRSVD(ds_train; features = features, lrate = lrate, lambda = lambda)

cf.train!(model, ds_train)

print(cf.aval(model, ds_test))
