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


InstallMethod( LinsNode, "standard method", [ IsGroup, IsPosInt ],
function(G, i)
	local r;

	r := rec(
		Grp := G,
		Index := i,
		MinimalSupergroups := [],
		MinimalSubgroups := [],
		TriedPrimes := []);

	Objectify( LinsNodeType, r );

	return r;
end);

InstallMethod( LinsGraph, "standard method", [ IsGroup, IsPosInt ],
function(G, n)
	local gr, r;

	r := LinsNode(G, 1);
	gr := rec(
		Root := r,
		IndexBound := n,
		Levels := [ rec(Index := 1, Nodes := [r]) ]);

	Objectify( LinsGraphType, gr );

	return gr;
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

InstallMethod( MinimalSupergroups, "for Lins Node", [ IsLinsNode],
function(r)
	return r!.MinimalSupergroups;
end);

InstallMethod( MinimalSubgroups, "for Lins Node", [ IsLinsNode],
function(r)
	return r!.MinimalSubgroups;
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
	while not IsEmpty(MinimalSupergroups(s)) do
		s := MinimalSupergroups(s)[1];
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

InstallMethod( Supergroups, "for Lins Node", [ IsLinsNode],
function(r)
	return LINS_allNodes(r, MinimalSupergroups, false);
end);

InstallMethod( Subgroups, "for Lins Node", [ IsLinsNode],
function(r)
	return LINS_allNodes(r, MinimalSubgroups, false);
end);

InstallOtherMethod( ListOp, "for Lins Graph", [ IsLinsGraph ],
function(gr)
	return Concatenation(List(gr!.Levels, level -> level.Nodes));
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

# Should subgroups under rH be computed?
BindGlobal( "LINS_DoCutStd",
function(gr, rH)
	return false;
end);

# Should the search be terminated?
# We have computed the subgroups under rK
# and are about to compute the subgroups under rH.
BindGlobal( "LINS_DoTerminateStd",
function(gr, rK, rH)
	return false;
end);

# Calculate the index list out of the targets
BindGlobal( "LINS_FilterTQuotientsStd",
function(gr, rH, QQ)
local G, H, n, I, Q;
	G := Grp(Root(gr));
	H := Grp(rH);
	n := IndexBound(gr);
	I := [];
	for Q in QQ do
		if Q[1] > n / Index(G,H) then
			break;
		fi;
		Add(I, Q[2]);
	od;
	return I;
end);

# Whether to compute the intersection of the groups rH and rK
# with the given index.
BindGlobal( "LINS_DoIntersectionStd",
function(gr, rH, rK, index)
	return true;
end);

# Whether to compute p-quotients under rH for the prime p
BindGlobal( "LINS_DoPQuotientStd",
function(gr, rH, p)
	return true;
end);

# Default options, immutable entries
BindGlobal( "LINS_DefaultOptions", Immutable(rec(
    DoSetParent := true,
	DoCut := LINS_DoCutStd,
	DoTerminate := LINS_DoTerminateStd,
	FilterTQuotients := LINS_FilterTQuotientsStd,
	DoIntersection := LINS_DoIntersectionStd,
	DoPQuotient := LINS_DoPQuotientStd
)));

BindGlobal( "LINS_SetOptions",
function(optionsBase, optionsUpdate)
    local r;
    for r in RecNames(optionsUpdate) do
        if not IsBound(optionsBase.(r)) then
            ErrorNoReturn("Invalid option: ", r);
        fi;
        optionsBase.(r) := optionsUpdate.(r);
    od;
end);

#############################################################################
## Calculate every normal subgroup of G up to index n
## The algorithm works only for n less equal the maximum index bound max_index
#############################################################################

InstallGlobalFunction( LowIndexNormal, function(args...)
	local G, n, phi, opts, gr, i, level, r, primes;

	if Length(args) < 2 or Length(args) > 3 then
		ErrorNoReturn("Unknown number of arguments!");
	fi;

	G := args[1];
	n := args[2];

	opts := ShallowCopy(LINS_DefaultOptions);
	if Length(args) = 3 then
		LINS_SetOptions(opts, args[3]);
	fi;

	# Check if we can work with the index
	if n > LINS_maxIndex then
		ErrorNoReturn("The index exceedes the maximal index boundary of the algorithm");
	fi;

	# Convert the group into an fp-group if possible.
	if not IsFpGroup(G) then
		phi := IsomorphismFpGroup(G);
		G := Image(phi);
	fi;

	gr := LinsGraph(G, n);

	if IsBound(phi) then
		gr!.iso := phi;
	fi;

	# Call T-Quotient Procedure on G
	LINS_FindTQuotients(gr, Root(gr), LINS_TargetsQuotient, opts);

	# Compute all primes up to n
	primes := LINS_AllPrimesUpTo(n);
	i := 1;

	while i <= Length(gr!.Levels) do
		level := gr!.Levels[i];
		if level.Index > (n / 2) then
			break;
		fi;
		for r in level.Nodes do
			# Search for possible P-Quotients
			LINS_FindPQuotients(gr, r, primes, opts);
			# Search for possible Intersections
			if i > 1 then
				LINS_FindIntersections(gr, r, opts);
			fi;
		od;
		i := i + 1;
	od;

	# Return every normal subgroup
	return gr;
end);
