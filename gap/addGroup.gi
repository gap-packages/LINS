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
##  LINS_IsSubgroupFp
#############################################################################
##  Description:
##
##  Returns true if `H` is a subgroup of `G`.
##  Both `H` and `G` must be subgroups of the same finitely presented group `P`.
##  We need coset tables of both `H` and `G` in the parent `P`.
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


#############################################################################
##  LINS_SetParent
#############################################################################
##  Description:
##
##  Sets parent and attributes for normal subgroup `H` of `G`.
#############################################################################

InstallGlobalFunction(LINS_SetParent,
function(H, G)
	SetParent(H, G);
	SetIsNormalInParent(H, true);
end);


#############################################################################
####=====================================================================####
##
## LINS Node Relations
##
####=====================================================================####
#############################################################################

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
##  LINS_AddGroup
#############################################################################
##  Input:
##
##	- gr : 		LINS graph
##  - H : 		normal subgroup of group contained in root node of gr
##  - Supers : 	list of LINS nodes containing some supergroups of H
##  - test :    whether to test if H is already contained in gr
##  - opts : 	LINS options (see documentation)
#############################################################################
##  Usage:
##
##  Every function that computed normal subgroups calls this function
##  to add the found subgroups into the LINS graph `gr`.
#############################################################################
##  Description:
##
##  Adds the group `H` to the LINS graph `gr`.
##  Returns false, if `H` was already contained in `gr`,
##  otherwise the LINS node `rH` that contains `H`.
#############################################################################

InstallGlobalFunction(LINS_AddGroup, function(gr, H, Supers, test, opts)
	local
	G,      		# group: 		located in the root node
					#				of LINS graph `gr`.
	rH,      		# LINS node: 	containing `H`
	n,				# pos-int: 		index bound of LINS graph `gr`.
	allSupergroups,	# [LINS node]:	supergroups of `rH`
	allSubgroups,	# [LINS node]:	subgroups of `rH`
	pos,			# pos-int:		position of level at index $[G : H]$
					#				in `gr!.Levels`
	level,			# LINS level:	at index $[G : H]$
	rK,				# LINS node: 	loop var
	K;              # group:		located in node `rK`

	G := Grp(Root(gr));
	rH := LinsNode(H, Index(G, H));

	# Search for correct level
	pos := PositionProperty(gr!.Levels, level -> level.Index = rH!.Index);
	# Level does not exist
	if pos = fail then
		pos := PositionProperty(gr!.Levels, level -> level.Index > rH!.Index);
		if pos = fail then
			pos := Length(gr!.Levels) + 1;
		fi;
		Add(gr!.Levels, rec(Index := rH!.Index, Nodes := [rH]), pos);
	else # Level exists
		level := gr!.Levels[pos];
		# If `test` is true, then check if the group `H`
		# is already contained in the LINS graph `gr`.
		if test then
			for rK in level.Nodes do
				K := Grp(rK);
				if LINS_IsSubgroupFp(K,H) then
					return false;
				fi;
			od;
		fi;
		Add(level.Nodes, rH);
	fi;

	# Search for all possible MinimalSupergroups of `H`.
	allSupergroups := [];
	for level in Reversed(gr!.Levels{[1 .. pos - 1]}) do
		for rK in level.Nodes do
			K := Grp(rK);
			if not (rK in allSupergroups) then
				if Index(rH) mod Index(rK) = 0 then
					if LINS_IsSubgroupFp(K, H) then
						LINS_AddRelations(rK, rH);
						allSupergroups := DuplicateFreeList(Concatenation(allSupergroups, [rK], Supergroups(rK)));
					fi;
				fi;
			fi;
		od;
	od;

	# Search for all possible MinimalSubgroups of `H`.
	allSubgroups := [];
	SortBy(allSubgroups, Index);
	for level in gr!.Levels{[pos + 1 .. Length(gr!.Levels)]} do
		for rK in level.Nodes do
			K := Grp(rK);
			if not (rK in allSubgroups) then
				if Index(rK) mod Index(rH) = 0 then
					if LINS_IsSubgroupFp(H, K) then
						LINS_AddRelations(rH, rK);
						allSubgroups := DuplicateFreeList(Concatenation(allSubgroups, [rK], Subgroups(rK)));
					fi;
				fi;
			fi;
		od;
	od;

	# It could happen, that we inserted `H` between two groups `A` and `B`
	# that did not contain an intermediate group before.
	# Thus we need to update the relations for the super/sub-groups of `H`.
	LINS_UpdateRelations(rH);

	return rH;
end);
