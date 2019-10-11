@testset "Model Learn Tests" begin
    df1 = createdummydatasetone()
    dataset1 = Persa.Dataset(df1)

    df2 = createdummydatasettwo()
    dataset2 = Persa.Dataset(df2, 10, 10)

    struct RandomModel{T} <: Persa.Model{T}
        preference::Persa.Preference{T}
        users::Int
        items::Int
    end

    RandomModel(dataset::Persa.Dataset) = RandomModel(dataset.preference, Persa.users(dataset), Persa.items(dataset))

    Persa.predict(model::RandomModel, user::Int, item::Int) = rand(model.preference.possibles)

    model1 = RandomModel(dataset1)
    model2 = RandomModel(dataset2)

    @testset "Dummy Tests" begin
        @test model1[1,1] > 0
    end
end
