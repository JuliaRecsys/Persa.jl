using Persa
using DatasetsCF
using Surprise

ds = DatasetsCF.MovieLens()

for (ds_train, ds_test) in Persa.KFolds(ds, 10)
  model = Surprise.IRSVD(ds_train)

  Persa.train!(model, ds_train)

  print(Persa.aval(model, ds_test, Persa.recommendation(ds)))
end
