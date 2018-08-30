using Persa
using Test

dataset[1] # (1, 1, 5, 2, NaN, 2, NaN)

dataset[1,1] # (Id(1), Id(1), Rating(5, Preferences))

dataset[1,2,1] # Rating(2, Preferences)

dataset[1,1,:] # Context(Rating(2, Preferences), 5, 2, NaN, 2, NaN)

dataset[1,1,:] # Context(Null)

dataset[1,1,:date] # date

contexts(dataset) # [:rating, :date, :day, :humor]

Rating(2, Preferences) + Rating(2, Preferences) = Rating(4, Preferences)

Rating(2, Preferences{Int}) + 2 = Rating(4, Preferences)

Rating(2, Preferences{Int}) + 2.1 = 4.1

Rating(2, Preferences) + 6 = Rating(5, Preferences)

mean([Rating(2, Preferences{Int}), ...]) = 3.5

mean([Rating(2, Preferences{Int}), Rating(Vazio, Preferences{Int}), ...]) = 3.0

Rating(2, Preference) > 2 # false

Rating(2, Preference) + 2 > 2 # true

Rating(2, Preference) + Rating(2, Preference) > 2 # true

Rating(2, Preference) > Rating(2, Preference) # false

Rating(Vazio, Preference) + 1 # Rating(Vazio, Preference)
