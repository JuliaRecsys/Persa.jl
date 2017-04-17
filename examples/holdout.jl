reload("Pers")
cf = Pers

ds = cf.MovieLens()

holdout = cf.HoldOut(ds, 0.9)

(ds_train, ds_test) = cf.get(holdout)

model = cf.SurpriseKNNWithMeans(ds_train; k = 60, min_k = 60)

cf.train!(model, ds_train)

print(cf.aval(model, ds_test, cf.recommendation(ds)))
