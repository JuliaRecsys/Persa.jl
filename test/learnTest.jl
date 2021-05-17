struct RandomModel{T} <: Persa.Model{T}
    preference::Persa.Preference{T}
    users::Int
    items::Int
end

RandomModel(dataset::Persa.Dataset) = RandomModel(dataset.preference, Persa.users(dataset), Persa.items(dataset))

@testset "Model Learn Tests" begin
    df1 = createdummydatasetone()
    dataset1 = Persa.Dataset(df1)

    df2 = createdummydatasettwo()
    dataset2 = Persa.Dataset(df2, 10, 10)

    Persa.predict(model::RandomModel, user::Int, item::Int) = item != 2 && user != 2 ? rand(model.preference.possibles) : missing

    model1 = RandomModel(dataset1)
    model2 = RandomModel(dataset2)

    @testset "Dummy Tests" begin
        @test model1[1,1] > 0

        values = model1[dataset1]
        @test length(values) == length(dataset1)

        values = model2[dataset2]
        @test length(values) == length(dataset2)

        @test ismissing(dataset1[3,6])

        @test ismissing(model1[2,2])
    end
end
