ds = cf.createdummydataset()

@test ds.users == 7
@test ds.items == 6
@test length(ds.preferences.possibles) == 9
@test ds.preferences.min == 1
@test ds.preferences.max == 5

for (ds_train, ds_test) in cf.KFolds(ds, 10)
  @test ds_train.users == 7
  @test ds_train.items == 6
  @test length(ds_train.preferences.possibles) == 9
  @test ds_train.preferences.min == 1
  @test ds_train.preferences.max == 5
  @test length(ds_train) != length(ds)
  @test length(ds_train) != size(ds_test)[1]
  @test length(ds) != size(ds_test)[1]
end

holdout = cf.HoldOut(ds, 0.9)

(ds_train, ds_test) = cf.get(holdout)
@test ds_train.users == 7
@test ds_train.items == 6
@test length(ds_train.preferences.possibles) == 9
@test ds_train.preferences.min == 1
@test ds_train.preferences.max == 5
@test length(ds_train) != length(ds)
@test length(ds_train) != size(ds_test)[1]
@test length(ds) != size(ds_test)[1]
