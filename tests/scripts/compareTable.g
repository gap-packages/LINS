CompareTable := function( GAP_fcts, GAP_counts, GAP_times, MAGMA_fcts, MAGMA_counts, MAGMA_times)
  local GAP_names, MAGMA_names, GAP_sort, MAGMA_sort, T;
  GAP_names := ["LowIndexNormal", "FindPQuotients", "FindTQuotients", "FindIntersections", "AddGroup", "MustCheckP", "FindPModules", "MTX.BasesMaximalSubmodules", "PullBackH"];
  MAGMA_names := [ "LowIndexNormalSubgroups", "FindPQuotients", "FindTs", "FindIntersections", "AddGroup", "MustCheckP", "TryPModules", "MaximalSubmodulesH", "PullBackH"];
  GAP_sort := List(GAP_names, x->Position(GAP_fcts,x));
  MAGMA_sort := List(MAGMA_names, x->Position(MAGMA_fcts,x));
  T := [];
  T[1] := GAP_names;
  T[2] := List(GAP_sort, i->GAP_counts[i]);
  T[3] := List(MAGMA_sort, i->MAGMA_counts[i]);
  T[4] := List(GAP_sort, i->GAP_times[i]);
  T[5] := List(MAGMA_sort, i->MAGMA_times[i]);
  return T;
end;
