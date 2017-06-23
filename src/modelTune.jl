using MLBase: gridtune
using Compat: @compat

function modeltune(dataset::CFDatasetAbstract, estfun::Function, params::@compat(Tuple{AbstractString, Any})...; verbose = true, k = 0.9, seed = NaN)
  if isnan(seed)
    ds_train, ds_test = get(HoldOut(dataset, k))
  else
    ds_train, ds_test = get(HoldOut(dataset, k, seed))
  end

  estfun2(args...) = estfun(ds_train, args...)

  evalfun2(model) = aval(model, ds_test).mae

  return r = gridtune(estfun2, evalfun2,
              params...;
              ord=Reverse,    # smaller msd value indicates better model
              verbose=verbose)   # show progress information
end
