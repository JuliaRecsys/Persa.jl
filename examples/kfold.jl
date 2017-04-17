reload("Pers")
cf = Pers

ds = cf.FilmTrust()

for (ds_train, ds_test) in cf.KFolds(ds, 10)
  model = CollaborativeFiltering.SurpriseKNNWithMeans(ds_train; k = 60, min_k = 60)

  cf.train!(model, ds_train)

  print(cf.aval(model, ds_test, cf.recommendation(ds)))
end
