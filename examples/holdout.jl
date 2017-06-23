using Persa

ds = Persa.createdummydataset()

holdout = Persa.HoldOut(ds, 0.9)

(ds_train, ds_test) = Persa.get(holdout)

model = Persa.GlobalMean(ds_train)

Persa.train!(model, ds_train)

print(Persa.aval(model, ds_test, Persa.recommendation(ds)))
