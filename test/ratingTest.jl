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

    rating = Persa.Rating(4, preference)
    userPreference = Persa.UserPreference(1, 1, rating)
    @test userPreference[1] == 1
    @test userPreference[2] == 1
    @test userPreference[3] == 4
    @test isnan(userPreference[3]) == false
    @test ismissing(userPreference[3]) == false

    @test string(rating) == "4"

    io = IOBuffer()
    show(io, rating)
    str = String(take!(io))
    @test str == "Rating: 4"

    @test string(userPreference) == "(user: 1, item: 1, rating: 4)"

    rating = Persa.PredictRating(4.5, preference)
    userPreference = Persa.UserPreference(2, 3, rating)
    @test userPreference[1] == 2
    @test userPreference[2] == 3
    @test userPreference[3] == 4.5
    @test !isnan(userPreference[3]) == true
    @test !ismissing(userPreference[3]) == true

    io = IOBuffer()
    show(io, rating)
    str = String(take!(io))
    @test str == "Rating: 4.5 (4)"

    @test string(rating) == "4.5 (4)"
    @test string(userPreference) == "(user: 2, item: 3, rating: 4.5 (4))"

    rating = Persa.MissingRating()
    userPreference = Persa.UserPreference(2, 3, rating)
    @test userPreference[1] == 2
    @test userPreference[2] == 3
    @test isnan(userPreference[3]) == true
    @test ismissing(userPreference[3]) == true

    io = IOBuffer()
    show(io, rating)
    str = String(take!(io))
    @test str == "Rating: missing"

    @test string(rating) == "missing"
    @test string(userPreference) == "(user: 2, item: 3, rating: missing)"
end
