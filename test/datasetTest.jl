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
        @testset "Cartesian Index Tests" begin
            for i = 1:size(df1)[1]
                user = df1[!, :user][i]
                item = df1[!, :item][i]
                rating = df1[!, :rating][i]
                @test Persa.value(dataset1[user, item]) == rating
            end

            for i = 1:size(df2)[1]
                user = df2[!, :user][i]
                item = df2[!, :item][i]
                rating = df2[!, :rating][i]
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
        end

        @testset "Column Index Tests" begin
            for user in 1:Persa.users(dataset1)
                for (_, item, rating) in dataset1[user, :]
                    @test dataset1[user, item] == rating
                end
            end

            for item in 1:Persa.items(dataset1)
                for (user, _, rating) in dataset1[:, item]
                    @test dataset1[user, item] == rating
                end
            end

            for user in 1:Persa.users(dataset2)
                for (_, item, rating) in dataset2[user, :]
                    @test dataset2[user, item] == rating
                end
            end

            for item in 1:Persa.items(dataset2)
                for (user, _, rating) in dataset2[:, item]
                    @test dataset2[user, item] == rating
                end
            end
        end

        @testset "Limits Tests" begin
            (users, items) = Persa.size(dataset1)

            @test_throws ArgumentError dataset1[users + 1, items]
            @test_throws ArgumentError dataset1[users, items + 1]
            @test_throws ArgumentError dataset1[users + 1, items + 1]
            @test_throws ArgumentError dataset1[(users * items) + 1]
        end
    end

    @testset "Column Index Tests" begin
        for user=1:Persa.users(dataset1)
            @test length(dataset1[user, :]) == length(dataset1[user, 1:end])
        end

        for item=1:Persa.items(dataset1)
            @test length(dataset1[:, item]) == length(dataset1[1:end, item])
        end

        for user=1:Persa.users(dataset2)
            @test length(dataset2[user, :]) == length(dataset2[user, 1:end])
        end

        for item=1:Persa.items(dataset2)
            @test length(dataset2[:, item]) == length(dataset2[1:end, item])
        end

        start = 2
        last = Persa.users(dataset1) - 1

        for item=1:Persa.items(dataset1)
            elements = dataset1[start:last, item]
            for element in elements
                @test element[1] >= start && element[1] <= last
            end
        end

        start = 2
        last = Persa.items(dataset1) - 1

        for user=1:Persa.users(dataset1)
            elements = dataset1[user, start:last]
            for element in elements
                @test element[2] >= start && element[2] <= last
            end
        end

        start = 2
        last = Persa.users(dataset2) - 1

        for item=1:Persa.items(dataset2)
            elements = dataset2[start:last, item]
            for element in elements
                @test element[1] >= start && element[1] <= last
            end
        end

        start = 2
        last = Persa.items(dataset2) - 1

        for user=1:Persa.users(dataset2)
            elements = dataset2[user, start:last]
            for element in elements
                @test element[2] >= start && element[2] <= last
            end
        end

        @test length(dataset1[1:end, 1:end]) == length(dataset1)
        @test length(dataset2[1:end, 1:end]) == length(dataset2)

        @test dataset1[1] == dataset1[[1]][1]
        @test dataset1[1] in dataset1[[1]]
        @test dataset1[1] in dataset1[[1, 2]]
        @test length(dataset1[[1,2,3]]) == 3

        @test dataset1[1] == dataset1[1:1][1]
        @test dataset1[1] in dataset1[1:1]
        @test dataset1[1] in dataset1[1:2]
        @test length(dataset1[1:3]) == 3

        @test dataset1[1] == dataset1[:][1]
        @test dataset1[1] in dataset1[:]
        @test dataset1[1] in dataset1[:]
        @test length(dataset1) == length(dataset1[:])
        @test length(dataset1) == length(dataset1[:, :])
    end

    @testset "Matrix Conversion Tests" begin
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

    @testset "Iterator Tests" begin
        for (user, item, rating) in dataset1
            @test rating == dataset1[user, item]
        end

        for (user, item, rating) in dataset2
            @test dataset2[user, item] == rating
        end
    end
end
