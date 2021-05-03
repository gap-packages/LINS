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

LINS_maxIndex := 10000000;

##
## The pregenerated list TargetsQuotient will contain the following information in form of tupels of any subgroup Q of
## Aut(T x T x ... x T), where T is a non-abelian simple group,
## such that (T x T x ... x T) is a subgroup of Q and Q acts transitively on the copies of T,
## with group order up to the maximum index boundary max_index.
## Let Q be such a group of interest, then the information about Q will be consisting of the following:
## 1 : the group order
## 2 : an index of some group S, that has trivial core in Q
## 3 : name of the group T^d
## The list TargetsQuotient is sorted by information 1.
##
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
  GroupsFound := FindTQuotients(GroupsFound, n, Current, TargetsQuotient);

  while Current <= Length(GroupsFound) and GroupsFound[Current].Index <= (n / 2) do
    # Search for possible P-Quotients
    GroupsFound := FindPQuotients(GroupsFound, n, Current);
    # Search for possible Intersections
    if Current > 1 then
      GroupsFound := FindIntersections(GroupsFound, n, Current);
    fi;
    # Search for normal subgroups in the next group
    Current := Current + 1;
  od;

  # Return every normal subgroup
  return GroupsFound;
end);
