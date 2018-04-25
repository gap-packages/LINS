TQuotient := function(QQ, G, n, H)
  local list, I, Q, LL, L, i, K, Iso, IH, PL;
  list := [];
  #Prepare the index list
  I := [];
  for Q in QQ do
    if Q[1] > n / Index(G,H) then
      break;
    fi;
    Add(I,Q[2]);
  od;
  I := SSortedList(I);
  if Length(I) = 0 then
    return list;
  fi;
  #Search the LowIndex Subgroups with correct index
  Iso := IsomorphismFpGroup(H);
  IH := Image(Iso);
  LL := LowIndexSubgroupsFpGroup(IH, I[Length(I)]);
  for L in LL do
    PL := PreImage(Iso, L);
    for i in I do
      if Index(G,PL) = i then
        K := Core(G, PL);
        if Index(G,K) <= n then
          Add(list,K);
        fi;
        break;
      fi;
    od;
  od;
  return list;
end;
