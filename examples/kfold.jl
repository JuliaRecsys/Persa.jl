reload("Persa")
cf = Persa

ds = cf.createdummydataset()

for (ds_train, ds_test) in cf.KFolds(ds, 10)
  model = cf.ImprovedRegularizedSVD(ds_train)

  cf.train!(model, ds_train)

  print(cf.aval(model, ds_test, cf.recommendation(ds)))
end
