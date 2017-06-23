struct HoldOut{T<:CFDatasetAbstract}
    dataset::T
    index::Array
    k::Float64
    T
end

function HoldOut{T<:CFDatasetAbstract}(dataset::T, margin::Float64, seed::Int)
  srand(seed);
  HoldOut(dataset, shuffle(collect(1:length(dataset))), margin, T)
end

HoldOut{T<:CFDatasetAbstract}(dataset::T, margin::Float64) = HoldOut(dataset, shuffle(collect(1:length(dataset))), margin, T)

get(holdout::HoldOut) = (getTrainData(holdout), getTestData(holdout))

function getTrainData(holdout::HoldOut)
  index = find(r -> r < length(holdout.dataset) * holdout.k, holdout.index);
  return holdout.T(holdout.dataset.file[index,:], holdout.dataset.users, holdout.dataset.items, holdout.dataset.preferences)
end

function getTestData(holdout::HoldOut)
  index = find(r -> r >= length(holdout.dataset) * holdout.k, holdout.index);
  return convert(Array, holdout.dataset.file[index,:])
end
