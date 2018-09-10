@testset "Datasets Kernel Tests" begin
    df1 = createdummydatasetone()
    dataset1 = Persa.Dataset(df1)

    df2 = createdummydatasettwo()
    dataset2 = Persa.Dataset(df2, 10, 10)

    @testset "Dummy Tests" begin
        @test dataset1.users == 7
        @test dataset1.items == 6
        @test Persa.users(dataset1) == 7
        @test Persa.items(dataset1) == 6

        @test dataset2.users == 10
        @test dataset2.items == 10
        @test Persa.users(dataset2) == 10
        @test Persa.items(dataset2) == 10

        @test Persa.size(dataset1) == (7, 6)
        @test Persa.size(dataset2) == (10, 10)

        @test Persa.length(dataset1) == 35
        @test Persa.length(dataset2) == 35
    end

    @testset "Index Tests" begin
        for i = 1:size(df1)[1]
            user = df1[:user][i]
            item = df1[:item][i]
            rating = df1[:rating][i]
            @test Persa.value(dataset1[user, item]) == rating
        end

        for i = 1:size(df2)[1]
            user = df2[:user][i]
            item = df2[:item][i]
            rating = df2[:rating][i]
            @test Persa.value(dataset2[user, item]) == rating
        end

        for i = 1:length(dataset1)
            (user, item, rating) = dataset1[i]
            @test dataset1[user, item] == rating
        end

        for i = 1:length(dataset2)
            (user, item, rating) = dataset2[i]
            @test dataset2[user, item] == rating
        end

        matrix = Array(dataset1)

        for user in 1:Persa.users(dataset1)
            for item in 1:Persa.items(dataset1)
                @test Persa.value(dataset1[user, item]) === matrix[user, item]
            end
        end

        matrix = Array(dataset2)

        for user in 1:Persa.users(dataset2)
            for item in 1:Persa.items(dataset2)
                @test Persa.value(dataset2[user, item]) === matrix[user, item]
            end
        end
    end
end
