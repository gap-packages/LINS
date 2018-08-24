##
## This finds the sizes of the minimal normal subgroups of
## G/H, where H is the group in the ’Current’ position in the list.
##
MinSubgroupSizes := function(GroupsFound, Current)
  m := GroupsFound[Current].Supergroups;
  minSupergroups := Filtered(m, s -> ForAny(m, t -> s in GroupsFound[t].Supergroups) = false);
  return List(minSupergroups, x -> Index(GroupsFound[1], GroupsFound[x]) / Index(GroupsFound[1], GroupsFound[Current]));
end;

## This function returns the size of the group GL(r,p).
OGL := function(r, p)
  i := 1;
  for j := 0 to (r-1) do
    i := i * (p^r - p^j);
  end for;
  return i;
end;

InstallGlobalFunction(MustCheckP, function(p, index, minSubSizes)
  local i,j, orderToCheck, r;
  
  for i in minSubSizes do
    if IsPowerOf(i, p) then
      return false;
    fi;
  end for;
  
  ordersToCheck := List( Filtered(TargetsQuotient, Q -> Q[3] mod p = 0), Q -> Q[1];
  for i in minSubgroupSizes do
    for j in ordersToCheck do
      if IsPowerOf(i, j) then
        return true;  
      fi;
    od;
  od;
  
  r := 1;
  while p^(r+1) <= n / index do
    r := r+1;
  od;
  if OGL(r, p) mod index = 0 then
    return true;
  fi;
  
  return false;
end);
