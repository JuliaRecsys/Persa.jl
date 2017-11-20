
@testset "Datasets Kernel Tests" begin

    ds = Persa.createdummydataset()

    @testset "Dummy Dataset" begin
        @test ds.users == 7
        @test ds.items == 6
        @test length(ds.preferences.possibles) == 9
        @test ds.preferences.min == 1
        @test ds.preferences.max == 5
    end

    @testset "Holdout" begin
        holdout = Persa.HoldOut(ds, 0.9)

        (ds_train, ds_test) = Persa.get(holdout)
        @test ds_train.users == 7
        @test ds_train.items == 6
        @test length(ds_train) != length(ds)
        @test length(ds_train) != size(ds_test)[1]
        @test length(ds) != size(ds_test)[1]
        @test Persa.sparsity(ds) >= 0
    end

    @testset "KFold" begin
        for (ds_train, ds_test) in Persa.KFolds(ds, 10)
          @test ds_train.users == 7
          @test ds_train.items == 6
          @test length(ds_train.preferences.possibles) == 9
          @test ds_train.preferences.min == 1
          @test ds_train.preferences.max == 5
          @test length(ds_train) != length(ds)
          @test length(ds_train) != size(ds_test)[1]
          @test length(ds) != size(ds_test)[1]
        end

        kfold = Persa.KFolds(ds, 10)
        @test length(kfold) == 10
    end

    @testset "Rating Preferences" begin
        holdout = Persa.HoldOut(ds, 0.9)

        (ds_train, ds_test) = Persa.get(holdout)

        @test length(ds_train.preferences.possibles) == 9
        @test ds_train.preferences.min == Base.minimum(ds_train.preferences)
        @test ds_train.preferences.max == Base.maximum(ds_train.preferences)
        @test eltype(ds_train.preferences) == Float64
        @test size(ds_train.preferences) == 9
        @test round(1.1, ds_train.preferences) == 1.0
        @test round(1, ds_train.preferences) == 1.0
        @test Persa.recommendation(ds_train) == 4.0
        @test Persa.recommendation(ds_train.preferences) == 4.0
        @test Persa.recommendation(ds_train.preferences) == Persa.recommendation(ds_train)

        @test Persa.correct(Inf, ds_train.preferences) == ds.preferences.max
        @test Persa.correct(-Inf, ds_train.preferences) == ds.preferences.min
    end

    @testset "Interfaces" begin
        (ds_train, ds_test) = Persa.get(Persa.HoldOut(ds, 0.9))
        (u, v, r) = ds_train[1]

        @test typeof(u) == Int
        @test typeof(v) == Int
        @test typeof(r) == Float64

        matrix = Persa.getmatrix(ds)

        @test matrix[1, 1] == 2.5
        (m, n) = size(matrix)
        @test m == ds_train.users
        @test n == ds_train.items
    end

    @testset "Others" begin
        ds_copy = copy(ds)
        @test ds_copy !== copy
        @test ds_copy.preferences === ds.preferences
        @test ds.file !== ds_copy.file
        @test ds.users == ds_copy.users
        @test ds.items == ds_copy.items
        @test length(ds.file) == length(ds_copy.file)
    end
end
