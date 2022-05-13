#############################################################################
##  findPQuotients.gi
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
## Let the group G be located in the list GroupsFound at position 1.
## Let the group H be located in the list GroupsFound at position Current.
## Calculate every normal subgroup K of G, such that H/K is a p-Group
## and the index in G is less equal n.
#############################################################################

InstallGlobalFunction(LINS_FindPQuotients, function(GroupsFound, n, Current, primes)
  local
    G,      # the parent group, which is stored at the first position in GroupsFound
    H,      # the group (record) at position Current
    p;      # loop variable, prime integer

  # References to the Groups in the list GroupsFound.
  G := GroupsFound[1].Group;
  H := GroupsFound[Current].Group;

  # Search for p-Quotients for every prime small enough.
  for p in primes do
    if p > n / Index(G, H) then
      break;
    fi;
    # Check according to some rules whether the p-Quotients will be computed by Intersections.
    if( LINS_MustCheckP(n, p, Index(G, H), LINS_MinSubgroupSizes(GroupsFound, Current)) ) then
      # Compute all p-Groups from H.
      GroupsFound := LINS_FindPModules(GroupsFound, n, Current, p);
    fi;
  od;

  # Return the updated list GroupsFound.
  return GroupsFound;
end);
