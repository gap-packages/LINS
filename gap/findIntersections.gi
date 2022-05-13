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

InstallGlobalFunction( LINS_FindIntersections, function(GroupsFound, n, Current)
  local
    H,          # the group (record) at postion Current
    Other,      # Loop variable, position of group to insersect
    K,          # the group (record) at position Other
    M,          # smallest supergroup (record) of H and K, being HK
    index,      # index of the intersection of H and K
    F;          # list of groups (positions), which could be the insersection of H and K

  # If the current group is G, then continue.
  if Current = 1 then
    return GroupsFound;
  fi;
  H := GroupsFound[Current];

  # Calculate intersections with every other group
  # in the list GroupsFound that are stored before the position Current
  for Other in [2..Current-1] do

    # If the other group is a supergroup of H, then continue;
    if Other in H.Supergroups then
      continue;
    fi;
    K := GroupsFound[Other];

    # Find the smallest supergroup of H and K. (which is HK)
    M := GroupsFound[Maximum(Intersection(H.Supergroups,K.Supergroups))];
    index := K.Index * H.Index / M.Index;

    # Check if we need to calculate the intersection
    if index >= n then
      continue;
    fi;

    # Check if the intersection has been already calculated
    F := Filtered([Current..Length(GroupsFound)], i -> GroupsFound[i].Index = index);
    if ForAny(F, i -> IsSubset(GroupsFound[i].Supergroups,[Current,Other])) then
      continue;
    fi;

    # Add the intersection to the list GroupsFound
    GroupsFound := LINS_AddGroup(GroupsFound, Intersection(H.Group,K.Group), [Other,Current], false)[1];
  od;

  # Return the updated list GroupsFound
  return GroupsFound;
end);
