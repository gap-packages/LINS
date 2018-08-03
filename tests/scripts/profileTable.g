# k is exponent for conversion of ms
# l is exponent for conversion of kb
ProfileTable := function(Fcts, k, l)
  local P, T;
  P := ProfileInfo(Fcts,0,0);
  P := P.prof;
  T := [];
  
  # Populate List with raw data
  T[1] := List(P, p->p[7]);
  T[2] := List(P, p->p[1]);
  T[3] := List(P, p->p[2] + p[3]);
  T[4] := List(P, p->p[3]);
  T[5] := List(P, p->Int( (p[4] + p[5]) / 1024 ));
  T[6] := List(P, p->Int( p[5] / 1024 ));

  
  # Convert raw data
  T[3] := List(T[3], x->DRAC(x,k,1));
  T[4] := List(T[4], x->DRAC(x,k,1));
  T[5] := List(T[5], x->DRAC(x,l,1));
  T[6] := List(T[6], x->DRAC(x,l,1));
  return T;
end;
