#############################################################################
##
##  This file is part of LINS, a package for the GAP computer algebra system
##  which provides a method for the computation of normal subgroups in a
##  finitely presented group.
##
##  This files's authors include Friedrich Rober.
##
##  SPDX-License-Identifier: GPL-3.0-or-later
##
#############################################################################

##
## The maximum index boundary the algorithm can work with
##

BindGlobal("LINS_maxIndex", 10000000);

##
## Calculate every normal subgroup of G up to index n
## The algorithm works only for n less equal the maximum index bound max_index
##
InstallGlobalFunction( LowIndexNormal, function(G, n)
  local GroupsFound, Current;

  # Check if we can work with the index
  if n > LINS_maxIndex then
    ErrorNoReturn("The index exceedes the maximal index boundary of the algorithm");
  fi;

  # Convert the group into an fp-group if possible.
  if not IsFpGroup(G) then
    G := Image(IsomorphismFpGroup(G));
  fi;

  # Initialize the list of already found normal subgroups consisting of records of the following form:
  # Group : the normal subgroup of G
  # Index : the index in G
  # SuperGroups : the position of every supergroup in the list GroupsFound
  GroupsFound := [rec(Group:=G, Index:=1, Supergroups := [], TriedPrimes := [])];
  Current := 1;

  # Call T-Quotient Procedure on G
  GroupsFound := LINS_FindTQuotients(GroupsFound, n, Current, TargetsQuotient);

  while Current <= Length(GroupsFound) and GroupsFound[Current].Index <= (n / 2) do
    # Search for possible P-Quotients
    GroupsFound := LINS_FindPQuotients(GroupsFound, n, Current);
    # Search for possible Intersections
    if Current > 1 then
      GroupsFound := LINS_FindIntersections(GroupsFound, n, Current);
    fi;
    # Search for normal subgroups in the next group
    Current := Current + 1;
  od;

  # Return every normal subgroup
  return GroupsFound;
end);
