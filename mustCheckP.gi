##
## This finds the sizes of the minimal normal subgroups of
## G/H, where H is the group in the ’Current’ position in the list.
##
MinSubgroupSizes := function(GroupsFound, Current)
  local m, minSupergroups;
  
  m := GroupsFound[Current].Supergroups;
  minSupergroups := Filtered(m, s -> ForAny(m, t -> s in GroupsFound[t].Supergroups) = false);
  
  return List(minSupergroups, x -> Index(GroupsFound[1].Group, GroupsFound[Current].Group) / Index(GroupsFound[1].Group, GroupsFound[x].Group) );
end;

## For positive integers a,b
## return true if a is some power of b;
IsPowerOf := function(a, b)
  local c;
  
  c := a;
  while c > 1 do
    if c mod b = 0 then
      c := QuoInt(c,b);
    else return false;
    fi;
  od;
    
  return true;  
end;

## This function returns the size of the group GL(r,p).
OGL := function(r, p)
  local i,j;
  
  i := 1;
  for j in [0..(r-1)] do
    i := i * (p^r - p^j);
  od;
  
  return i;
end;

InstallGlobalFunction(MustCheckP, function(n, p, index, minSubSizes)
  local i,j, ordersToCheck, r;
  
  for i in minSubSizes do
    if IsPowerOf(i, p) then
      return false;
    fi;
  od;
  
  ordersToCheck := List( Filtered(TargetsCharSimple, Q -> Q[3] mod p = 0), Q -> Q[1]);
  for i in minSubSizes do
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
