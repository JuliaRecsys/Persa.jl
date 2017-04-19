reload("Persa")
cf = Persa

ds = cf.createdummydataset()

for (ds_train, ds_test) in cf.KFolds(ds, 10)
  model = cf.SurpriseKNNWithMeans(ds_train; k = 60, min_k = 60)

  cf.train!(model, ds_train)

  print(cf.aval(model, ds_test, cf.recommendation(ds)))
end
