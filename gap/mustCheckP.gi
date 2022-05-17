#############################################################################
##  mustCheckP.gi
#############################################################################
##
##  This file is part of the LINS package.
##
##  This file's authors include Friedrich Rober.
##
##  Please refer to the COPYRIGHT file for details.
##
##  SPDX-License-Identifier: GPL-2.0-or-later
##
#############################################################################


#############################################################################
## This finds the sizes of the minimal normal subgroups of
## G/H, where H is the group in the position Current in the list.
#############################################################################

InstallGlobalFunction(LINS_MinSubgroupSizes, function(rH)
  return List(MinimalSupergroups(rH), rK -> Index(rH) / Index(rK) );
end);


#############################################################################
## For positive integers a,b
## return true if a is some power of b;
#############################################################################
InstallGlobalFunction(LINS_IsPowerOf, function(a, b)
  local c;

  c := a;
  while c > 1 do
    if c mod b = 0 then
      c := QuoInt(c,b);
    else return false;
    fi;
  od;

  return true;
end);


#############################################################################
## This function returns the size of the group GL(r,p).
#############################################################################

InstallGlobalFunction(LINS_OGL, function(r, p)
  local i,j;

  i := 1;
  for j in [0..(r-1)] do
    i := i * (p^r - p^j);
  od;

  return i;
end);


#############################################################################
## This function checks if p-Quotients have to be computed. Otherwise the groups can be expressed as Intersections of bigger groups.
## n is the maximal index, p a prime, index is the index of some group H and minSubSizes are the sizes computed by a call of LINS_MinSubgroupSizes on H.
#############################################################################

InstallGlobalFunction(LINS_MustCheckP, function(n, p, index, minSubSizes)
  local i,j, ordersToCheck, r;

  for i in minSubSizes do
    if LINS_IsPowerOf(i, p) then
      return false;
    fi;
  od;

  # orders of Characteristically Simple Groups, where p is a divisor of the order of the schur multiplier
  ordersToCheck := List( Filtered(LINS_TargetsCharSimple, Q -> p in Q[2]), Q -> Q[1]);
  for i in minSubSizes do
    for j in ordersToCheck do
      if i = j then
        return true;
      fi;
    od;
  od;

  r := 1;
  while p^(r+1) <= n / index do
    r := r+1;
  od;
  if LINS_OGL(r, p) mod index = 0 then
    return true;
  fi;

  return false;
end);
