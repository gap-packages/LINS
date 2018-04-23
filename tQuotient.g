TQuotient := function(QQ, G, n, H)
  local NormalSubgroups, I, Q, LL, L, i, K;
  NormalSubgroups := [];
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
    return NormalSubgroups;
  fi;
  #Search the LowIndex Subgroups with correct index
  LL := LowIndexSubgroupsFpGroup(H, I[Length(I)]);
  for L in LL do
    for i in I do
      if Index(G,L) = i then
        K := Core(G, L);
        if Index(G,K) <= n then
          Add(NormalSubgroups,K);
        fi;
        break;
      fi;
    od;
  od;
  return NormalSubgroups;
end;
