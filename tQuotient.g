TQuotient := function(GroupsFound, n, Current, QQ)
  local G, H, I, Q, m, LL, L, i, K, Iso, IH, PL;
  G := GroupsFound[1].Group;
  H := GroupsFound[Current].Group;
    #Prepare the index list
  I := [];
  for Q in QQ do
    if Q[1] > n / Index(G,H) then
      break;
    fi;
    Add(I,Q[2]);
  od;
  if Length(I) = 0 then
    return GroupsFound;
  fi;
  m := Maximum(I);
    # Search the LowIndex Subgroups with correct index
  Iso := IsomorphismFpGroup(H);
  IH := Image(Iso);
  LL := LowIndexSubgroupsFpGroup(IH, m);
  for L in LL do
    PL := PreImage(Iso, L);
    for i in I do
      if Index(G,PL) = i then
        K := Core(G, PL);
        if Index(G,K) <= n then
          GroupsFound := AddGroup(GroupsFound,K,[1],true);
        fi;
        break;
      fi;
    od;
  od;
  return GroupsFound;
end;
