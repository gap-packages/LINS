#############################################################################
##  LINS.gi
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


InstallMethod( LinsNode, "standard method", [ IsGroup, IsPosInt, IsList, IsList ],
function(G, i, supergroups, triedPrimes)
	local r;

	r := rec(
		Grp := G,
		Index := i,
		Supergroups := supergroups,
		Subgroups := [],
		TriedPrimes := triedPrimes);

	Objectify( LinsNodeType, r );

	return r;
end);

InstallOtherMethod( LinsNode, "for three arguments", [ IsGroup, IsPosInt, IsList ],
function(G, i, supergroups)
	return LinsNode(G, i, supergroups, []);
end);

InstallMethod( LinsGraph, "standard method", [ IsGroup, IsPosInt ],
function(G, n)
	local gr, r;

	r := LinsNode(G, 1, []);
	gr := rec(
		Root := r,
		IndexBound := n,
		Levels := [ rec(Index := 1, Nodes := [r]) ],
		);

	Objectify( LinsGraphType, r );

	return r;
end);

InstallMethod( \=, "for Lins Node", [IsLinsNode, IsLinsNode], IsIdenticalObj);

InstallMethod( ViewObj, "for Lins Node", [IsLinsNode],
function(r)
	Print("<lins node of index ", Index(r), ">");
end);

InstallMethod( ViewObj, "for Lins Graph Node", [IsLinsGraph],
function(gr)
	Print("<lins graph found ", Length(List(gr)), " normal subgroups up to index ", IndexBound(gr), ">");
end);


InstallOtherMethod( Grp, "for Lins Node", [ IsLinsNode ],
function(r)
	return r!.Grp;
end);

InstallOtherMethod( Index, "for Lins Node", [ IsLinsNode ],
function(r)
	return r!.Index;
end);

InstallMethod( Supergroups, "for Lins Node", [ IsLinsNode],
function(r)
	return r!.Supergroups;
end);

InstallMethod( Subgroups, "for Lins Node", [ IsLinsNode],
function(r)
	return r!.Subgroups;
end);

InstallMethod( TriedPrimes, "for Lins Node", [ IsLinsNode ],
function(r)
	return r!.TriedPrimes;
end);

InstallMethod( IsCut, "for Lins Node", [ IsLinsNode ],
function(r)
	if IsBound(r!.IsCut) then
		return r!.IsCut;
	else
		return false;
	fi;
end);

InstallMethod( Root, "for Lins Graph", [ IsLinsGraph ],
function(r)
	return r!.Root;
end);

InstallOtherMethod( Root, "for Lins Node", [ IsLinsNode ],
function(r)
	local s;
	s := r;
	while not IsEmpty(Supergroups(s)) do
		s := Supergroups(s)[1];
	od;
	return s;
end);

BindGlobal( "LINS_allNodes",
function(r, next, shouldIncludeSelf)
	local queue, s, t, nextNodes, allNodes;
	queue := [r];
	if shouldIncludeSelf then
		allNodes := [r];
	else
		allNodes := [];
	fi;
	while not IsEmpty(queue) do
		s := Remove(queue, 1);
		nextNodes := next(s);
		for t in nextNodes do
			if not t in allNodes then
				Add(allNodes, t);
				Add(queue, t);
			fi;
		od;
	od;
	return allNodes;
end);

InstallOtherMethod( ListOp, "for Lins Graph", [ IsLinsGraph ],
function(gr)
	return List(LINS_allNodes(Root(gr), Subgroups, true), Grp);
end);


InstallMethod( Output, "for Lins Graph", [ IsLinsGraph ],
function(gr)
	if IsBound(gr!.Output) then
		return gr!.Output;
	else
		return List(gr);
	fi;
end);

InstallMethod( IndexBound, "for Lins Graph", [ IsLinsGraph ],
function(gr)
	return gr!.IndexBound;
end);


#############################################################################
## The maximum index boundary the algorithm can work with
#############################################################################

BindGlobal("LINS_maxIndex", 10000000);


#############################################################################
## Calculate every normal subgroup of G up to index n
## The algorithm works only for n less equal the maximum index bound max_index
#############################################################################

InstallGlobalFunction( LowIndexNormal, function(G, n)
	local GroupsFound, Current, primes;

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
	GroupsFound := LINS_FindTQuotients(GroupsFound, n, Current, LINS_TargetsQuotient);

	# Compute all primes up to n
	primes := LINS_AllPrimesUpTo(n);

	while Current <= Length(GroupsFound) and GroupsFound[Current].Index <= (n / 2) do
		# Search for possible P-Quotients
		GroupsFound := LINS_FindPQuotients(GroupsFound, n, Current, primes);
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
