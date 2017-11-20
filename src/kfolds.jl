struct KFolds{T<:CFDatasetAbstract}
    dataset::T
    index::Array
    k::Int
    T
end

KFolds{T<:CFDatasetAbstract}(dataset::T, k::Int) = KFolds(dataset, splitKFold(length(dataset), k), k, T)

getTrainIndex(kfold::KFolds, fold::Int) = find(r -> r != fold, kfold.index)
getTestIndex(kfold::KFolds, fold::Int) = find(r -> r == fold, kfold.index)

Base.start(kf::KFolds) = 1
Base.done(kf::KFolds, state) = state > kf.k
Base.next(kf::KFolds, state) = kf[state], state + 1

Base.getindex(kf::KFolds, idx) = kf.T(kf.dataset.file[getTrainIndex(kf, idx),:], kf.dataset.users, kf.dataset.items, kf.dataset.preferences), convert(Array, kf.dataset.file[getTestIndex(kf, idx),:])
Base.length(kf::KFolds) = kf.k

function splitKFold(y, num_folds)
  i = shuffle(collect(1:y));
  fold_size = round(Int, floor(y/num_folds));
  remainder = y-num_folds*fold_size;
  groups = zeros(Int, y);
  cursor = 1;
  group = 1;

  while cursor<=y
    this_fold_size = group <= remainder ? fold_size+1:fold_size;
    groups[i[cursor:cursor+this_fold_size-1]] = group;
    group += 1;
    cursor += this_fold_size;
  end

  return groups;
end
