@testset "Rating Kernel Tests" begin
    preference = Persa.Preference([1, 2, 3, 4, 5])

    @test Persa.value(Persa.MissingRating()) === missing
    @test Persa.value(Persa.MissingRating{Int}()) === missing

    @test Persa.value(Persa.Rating(4, preference)) == 4
    @test Persa.value(Persa.Rating(6, preference)) == Persa.maximum(preference)
    @test Persa.value(Persa.Rating(-1, preference)) == Persa.minimum(preference)

    @test Persa.value(Persa.PredictRating(4, preference)) == 4
    @test Persa.value(Persa.PredictRating(6, preference)) == Persa.maximum(preference)
    @test Persa.value(Persa.PredictRating(-1, preference)) == Persa.minimum(preference)
    @test Persa.value(Persa.PredictRating(5.5, preference)) == Persa.maximum(preference)
    @test Persa.value(Persa.PredictRating(-1.1, preference)) == Persa.minimum(preference)
    @test Persa.value(Persa.PredictRating(4.1, preference)) == 4.1

    predict = Persa.PredictRating(4.5, preference)
    label = Persa.Rating(4, preference)
end
