@testset "Model Tests" begin

    ds = Persa.createdummydataset()
    (ds_train, ds_test) = Persa.get(Persa.HoldOut(ds, 0.9))

    μ = Persa.mean(ds_train)

    model = Persa.GlobalMean(ds_train)
    Persa.train!(model, ds_train)

    @testset "Model" begin
        @test model.μ == μ
        @test Persa.predict(model, 1, 1) == μ
    end

    @testset "Measures" begin
        measures = Persa.aval(model, ds_test)
        @test Persa.mae(measures) >= 0.0
        @test Persa.rmse(measures) >= 0.0
        @test Persa.coverage(measures) >= 1.0

        measures = Persa.aval(model, ds_test, Persa.recommendation(ds_train))

        @test Persa.f1score(measures) == 0.0 || isnan(Persa.f1score(measures))
        @test Persa.recall(measures) == 0.0
        @test isnan(Persa.precision(measures))

        @test Persa.mae(measures) >= 0.0
        @test Persa.rmse(measures) >= 0.0
        @test Persa.coverage(measures) >= 1.0
    end

    @testset "Auxiliar Methods" begin
        @test length(Persa.means(ds)) == ds.users
        @test length(Persa.means(ds, mode = :user)) == ds.users
        @test length(Persa.means(ds, mode = :item)) == ds.items

        @test length(Persa.histogram(ds)) == size(ds.preferences)
        @test length(Persa.histogram(ds, mode = :user)) == ds.users
        @test length(Persa.histogram(ds, mode = :item)) == ds.items
    end
end
