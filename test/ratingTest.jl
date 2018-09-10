@testset "Rating Kernel Tests" begin
    preference = Persa.Preference([1, 2, 3, 4, 5])
    @test Perva.value(Persa.Rating(4.4, preference)) = 4
end
