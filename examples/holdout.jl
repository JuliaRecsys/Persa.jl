reload("Persa")
cf = Persa

ds = cf.createdummydataset()

holdout = cf.HoldOut(ds, 0.9)

(ds_train, ds_test) = cf.get(holdout)

model = cf.GlobalMean(ds_train)

cf.train!(model, ds_train)

print(cf.aval(model, ds_test, cf.recommendation(ds)))
