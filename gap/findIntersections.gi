#############################################################################
##  findIntersections.gi
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
## Calculate all pairwise intersections of the group H
## with all other groups in the list GroupsFound that are stored before the position Current.
## Add any normal subgroup found as an intersection and index in G less equal n,
## by calling the LINS_AddGroup-function
#############################################################################

InstallGlobalFunction( LINS_FindIntersections, function(gr, rH)
  local
    H,          # the group (record) at postion Current
    n, rK, allSupergroups, allSubgroups, supers, subs, pos, level, xgroups,
    Other,      # Loop variable, position of group to insersect
    K,          # the group (record) at position Other
    rM,          # smallest supergroup (record) of H and K, being HK
    index,      # index of the intersection of H and K
    F;          # list of groups (positions), which could be the insersection of H and K

  # If the current group is G, then continue.
  if Root(gr) = rH then
    return;
  fi;
  H := Grp(rH);
  n := IndexBound(gr);

  # Calculate intersections with every other group
  # in the list GroupsFound that are stored before the position Current
  allSupergroups := LINS_allNodes(rH, Supergroups, false);
  allSubgroups := LINS_allNodes(rH, Subgroups, false);
  for level in gr!.Levels{[1 .. PositionProperty(gr!.Levels, level -> level.Index = Index(rH))]} do
    for rK in level.Nodes do
      if rK = rH then
        break;
      fi;
      # If the other group is a supergroup of H, then continue;
      if rK in allSupergroups then
        continue;
      fi;
      K := Grp(rK);

      # Find the smallest supergroup of H and K. (which is HK)
      xgroups := LINS_allNodes(rK, Supergroups, false);
      supers := Filtered(allSupergroups, s -> s in xgroups);
      pos := PositionMaximum(List(supers, Index));
      rM := supers[pos];
      index := rK!.Index * rH!.Index / rM!.Index;

      # Check if we need to calculate the intersection
      if index >= n then
        continue;
      fi;

      # Check if the intersection has been already calculated
      xgroups := LINS_allNodes(rK, Subgroups, false);
      subs := Filtered(allSubgroups, s -> s in xgroups);
      if not (index in List(subs, Index)) then
        # Add the intersection to the list GroupsFound
        LINS_AddGroup(gr, Intersection(K, H), [rK, rH], true);
      fi;
    od;
  od;
end);
