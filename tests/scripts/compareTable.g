CompareTable := function( GAP_counts, GAP_times, GAP_fcts, MAGMA_counts, MAGMA_times, MAGMA_fcts)
  GAP_names := ["LowIndexNormal", "FindPQuotients", "FindTQuotients", "FindIntersections", "AddGroup"];
  MAGMA_names := [ "LowIndexNormalSubgroups", "FindPQuotients", "FindTs", "FindIntersections", "AddGroup"];
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
