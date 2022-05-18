#############################################################################
##  addGroup.gi
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
## Returns true if H is a subgroup of G.
## Both H and G must be subgroups of the same finitely presented group.
## We need coset tables of both H and G in the supergroup.
#############################################################################

InstallGlobalFunction(LINS_IsSubgroupFp, function(G, H)
  local word;

  for word in AugmentedCosetTableInWholeGroup(H).primaryGeneratorWords do
    if RewriteWord(AugmentedCosetTableInWholeGroup(G), word) = fail then
      return false;
    fi;
  od;

  return true;
end);

# K < H
BindGlobal("LINS_AddRelations",
function(rH, rK)
  Add(MinimalSupergroups(rK), rH);
  Add(MinimalSubgroups(rH), rK);
  # Stable Sort
  SortBy(MinimalSupergroups(rK), Index);
  SortBy(MinimalSubgroups(rH), Index);
end);

# K < H
BindGlobal("LINS_RemoveRelations",
function(rH, rK)
  local pos;

  pos := Position(MinimalSupergroups(rK), rH);
  Remove(MinimalSupergroups(rK), pos);
  pos := Position(MinimalSubgroups(rH), rK);
  Remove(MinimalSubgroups(rH), pos);
end);

BindGlobal("LINS_UpdateRelations",
function(rH)
  local subs, supers, toRemove, rK, rL, pair;

  subs := Subgroups(rH);
  toRemove := [];
  for rK in MinimalSupergroups(rH) do
    for rL in MinimalSubgroups(rK) do
      if rL in subs then
        Add(toRemove, [rK, rL]);
      fi;
    od;
  od;
  supers := Supergroups(rH);
  for rK in MinimalSubgroups(rH) do
    for rL in MinimalSupergroups(rK) do
      if rL in supers then
        Add(toRemove, [rL, rK]);
      fi;
    od;
  od;
  toRemove := DuplicateFreeList(toRemove);
  for pair in toRemove do
    LINS_RemoveRelations(pair[1], pair[2]);
  od;
end);


#############################################################################
## Add the group H to the list GroupsFound.
## Supers is a list of positions of supergroups in the list GroupsFound.
## If test is true, then it is checked, if the group H is not already contained in the list GroupsFound.
## The group H will be inserted in the list GroupsFound after the last group with smaller or equal index in G.
## All references to positions of supergroups will get updated in the list GroupsFound.
## The function returns a tupel with the updated list and the position where H can be found in the new list.
#############################################################################

InstallGlobalFunction(LINS_AddGroup, function(gr, H, Supers, test, opts)
  local
    G,                      # the parent group, which is stored at the first position in GroupsFound
    rH, rK, pos, level, allSupergroups, allSubgroups,
    NewGroupsFound,         # the updated list of groups after insertion of H
    Current,                # Loop variable, position of current group to be inserted
    K,                      # the group (record) at position Current
    S,                      # supergroups entry of K
    I,                      # set of positions
    J,                      # set of positions
    Subs;                   # subgroups of K

  G := Grp(Root(gr));
  rH := LinsNode(H, Index(G, H));

  # Search for correct level
  pos := PositionProperty(gr!.Levels, level -> level.Index = rH!.Index);
  # level does not exist
  if pos = fail then
    pos := PositionProperty(gr!.Levels, level -> level.Index > rH!.Index);
    if pos = fail then
      pos := Length(gr!.Levels) + 1;
    fi;
    Add(gr!.Levels, rec(Index := rH!.Index, Nodes := [rH]), pos);
  # If test is true, then check if the group H is already contained in the list.
  else
    level := gr!.Levels[pos];
    if test then
      for rK in level.Nodes do
        K := Grp(rK);
        if LINS_IsSubgroupFp(K,H) then
          return rK;
        fi;
      od;
    fi;
    Add(level.Nodes, rH);
  fi;

  # Search for all possible MinimalSupergroups of H.
  allSupergroups := [];
  for level in Reversed(gr!.Levels{[1 .. pos - 1]}) do
    for rK in level.Nodes do
      K := Grp(rK);
      if not (rK in allSupergroups) then
        if Index(rH) mod Index(rK) = 0 then
          if LINS_IsSubgroupFp(K, H) then
            LINS_AddRelations(rK, rH);
            allSupergroups := DuplicateFreeList(Concatenation(allSupergroups, Supergroups(rK)));
          fi;
        fi;
      fi;
    od;
  od;

  # Search for all possible Subgroups of H.
  allSubgroups := [];
  SortBy(allSubgroups, Index);
  for level in gr!.Levels{[pos + 1 .. Length(gr!.Levels)]} do
    for rK in level.Nodes do
      K := Grp(rK);
      if not (rK in allSubgroups) then
        if Index(rK) mod Index(rH) = 0 then
          if LINS_IsSubgroupFp(H, K) then
            LINS_AddRelations(rH, rK);
            allSubgroups := DuplicateFreeList(Concatenation(allSubgroups, Subgroups(rK)));
          fi;
        fi;
      fi;
    od;
  od;

  LINS_UpdateRelations(rH);

  return rH;
end);
