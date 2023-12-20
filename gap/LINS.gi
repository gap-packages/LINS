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


#############################################################################
####=====================================================================####
##
## LINS Node
##
####=====================================================================####
#############################################################################

InstallMethod( LinsNode, "standard method", [ IsGroup, IsPosInt],
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

InstallMethod( \=, "for Lins Node", [IsLinsNode, IsLinsNode], IsIdenticalObj);

InstallMethod( ViewObj, "for Lins Node", [IsLinsNode],
function(r)
    Print("<lins node of index ", Index(r), ">");
end);

InstallOtherMethod( Grp, "for Lins Node", [ IsLinsNode ],
function(r)
    return r!.Grp;
end);

InstallOtherMethod( Index, "for Lins Node", [ IsLinsNode ],
function(r)
    return r!.Index;
end);

InstallMethod( LinsNodeMinimalSupergroups, "for Lins Node", [ IsLinsNode],
function(r)
    return r!.MinimalSupergroups;
end);

InstallMethod( LinsNodeMinimalSubgroups, "for Lins Node", [ IsLinsNode],
function(r)
    return r!.MinimalSubgroups;
end);

InstallMethod( LinsNodeTriedPrimes, "for Lins Node", [ IsLinsNode ],
function(r)
    return r!.TriedPrimes;
end);

InstallMethod( LinsNodeIsCut, "for Lins Node", [ IsLinsNode ],
function(r)
    if IsBound(r!.IsCut) then
        return r!.IsCut;
    else
        return false;
    fi;
end);

InstallOtherMethod( LinsRoot, "for Lins Node", [ IsLinsNode ],
function(r)
    local s;
    s := r;
    while not IsEmpty(LinsNodeMinimalSupergroups(s)) do
        s := LinsNodeMinimalSupergroups(s)[1];
    od;
    return s;
end);

BindGlobal( "LINS_AllNodes",
function(r, next)
    local queue, s, t, nextNodes, allNodes;
    queue := [r];
    allNodes := [];
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

InstallMethod( LinsNodeSupergroups, "for Lins Node", [ IsLinsNode],
function(r)
    return LINS_AllNodes(r, LinsNodeMinimalSupergroups);
end);

InstallMethod( LinsNodeSubgroups, "for Lins Node", [ IsLinsNode],
function(r)
    return LINS_AllNodes(r, LinsNodeMinimalSubgroups);
end);


#############################################################################
####=====================================================================####
##
## LINS Graph
##
####=====================================================================####
#############################################################################

InstallMethod( LinsGraph, "standard method", [ IsGroup, IsPosInt ],
function(G, n)
    local gr, r;

    r := LinsNode(G, 1);
    gr := rec(
        LinsRoot := r,
        IndexBound := n,
        Levels := [ rec(Index := 1, Nodes := [r]) ]);

    Objectify( LinsGraphType, gr );

    return gr;
end);

InstallMethod( ViewObj, "for Lins Graph Node", [IsLinsGraph],
function(gr)
    Print("<lins graph contains ", Length(List(gr)), " normal subgroups up to index ", IndexBound(gr), ">");
end);


InstallMethod( LinsRoot, "for Lins Graph", [ IsLinsGraph ],
function(r)
    return r!.LinsRoot;
end);

InstallOtherMethod( ListOp, "for Lins Graph", [ IsLinsGraph ],
function(gr)
    return Concatenation(List(gr!.Levels, level -> level.Nodes));
end);

InstallMethod( ComputedNormalSubgroups, "for Lins Graph", [ IsLinsGraph ],
function(gr)
    if IsBound(gr!.ComputedNormalSubgroups) then
        return gr!.ComputedNormalSubgroups;
    else
        return List(gr);
    fi;
end);

InstallMethod( IndexBound, "for Lins Graph", [ IsLinsGraph ],
function(gr)
    return gr!.IndexBound;
end);

InstallMethod( LinsOptions, "for Lins Graph", [ IsLinsGraph ],
function(gr)
    return gr!.Options;
end);

InstallOtherMethod( IsomorphismFpGroup, "for Lins Graph", [ IsLinsGraph ],
function(gr)
    if IsBound(gr!.Iso) then
        return gr!.Iso;
    else
        return IdentityMapping(Grp(LinsRoot(gr)));
    fi;
end);

#############################################################################
####=====================================================================####
##
## LINS Options
##
####=====================================================================####
#############################################################################

# Append data to the LINS graph
BindGlobal( "LINS_InitGraph",
function(gr)
    return;
end);

# Should subgroups under `rH` be computed?
BindGlobal( "LINS_DoCut",
function(gr, rH)
    return false;
end);

# Should the search be terminated?
# We are currently computing the subgroups under `rH`.
# We have computed the normal subgroup `rK`.
# This function may write data to `gr!.ComputedNormalSubgroups`.
BindGlobal( "LINS_DoTerminate",
function(gr, rH, rK)
    return false;
end);

# Compute the index list from the targets
BindGlobal( "LINS_FilterTQuotients",
function(gr, targets)
local n, filteredTargets, entry;
    n := IndexBound(gr);
    filteredTargets := [];
    for entry in targets do
        if entry[1] > n then
            break;
        fi;
        Add(filteredTargets, entry);
    od;
    return filteredTargets;
end);

# Whether to compute the intersection of the groups `rH` and `rK`
# with the given index.
BindGlobal( "LINS_DoIntersection",
function(gr, rH, rK, index)
    return true;
end);

# Whether to compute `p`-quotients under `rH` for the prime `p`
BindGlobal( "LINS_DoPQuotient",
function(gr, rH, p)
    return true;
end);

# Whether to compute the elem. abelian `p`-quotient of given index
# under `rH` for the prime `p`
BindGlobal( "LINS_DoPModule",
function(gr, rH, p, index)
    return true;
end);

# Default options, immutable entries
BindGlobal( "LINS_DefaultOptions", Immutable(rec(
    DoSetParent := true,
    UseLIS := false,
    InitGraph := LINS_InitGraph,
    DoCut := LINS_DoCut,
    DoTerminate := LINS_DoTerminate,
    FilterTQuotients := LINS_FilterTQuotients,
    DoIntersection := LINS_DoIntersection,
    DoPQuotient := LINS_DoPQuotient,
    DoPModule := LINS_DoPModule
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

BindGlobal( "LINS_AppendOptions",
function(optionsBase, optionsUpdate)
    local r;
    for r in RecNames(optionsUpdate) do
        if IsBound(optionsBase.(r)) then
            ErrorNoReturn("Option already set: ", r);
        fi;
        optionsBase.(r) := optionsUpdate.(r);
    od;
end);



#############################################################################
####=====================================================================####
##
## Low Index Normal LinsNodeSubgroups (Search Graph)
##
####=====================================================================####
#############################################################################

# The maximal index bound for the algorithm `LowIndexNormalSubgroupsSearch`
BindGlobal("LINS_MaxIndex", Minimum(
    LINS_TargetsCharSimple_Index,
    LINS_TargetsQuotient_Index
    ));

# The maximal index bound for the algorithm `LowIndexNormalSubgroupsSearch`,
# if the `UseLIS` parameter is set to true.
BindGlobal("LINS_MaxIndex_UseLIS", Minimum(
    LINS_TargetsCharSimple_Index,
    LINS_TargetsQuotient_UseLIS_Index
    ));


# See documentation
InstallGlobalFunction( LowIndexNormalSubgroupsSearch, function(args...)
    local G, n, phi, opts, maxIndex, gr, i, j, l, level, r, s, primes, data, nrFound, res, par;

    if Length(args) < 2 or Length(args) > 3 then
        ErrorNoReturn("Unknown number of arguments!");
    fi;

    G := args[1];
    n := args[2];

    if not IsGroup(G) then
        ErrorNoReturn("<G> must be a group!");
    fi;

    if not IsPosInt(n) then
        ErrorNoReturn("<n> must be a positive integer!");
    fi;

    opts := ShallowCopy(LINS_DefaultOptions);
    if Length(args) = 3 then
        LINS_SetOptions(opts, args[3]);
    fi;

    if opts.UseLIS then
        maxIndex := LINS_MaxIndex_UseLIS;
    else
        maxIndex := LINS_MaxIndex;
    fi;

    # Check if we can work with the index
    if n > maxIndex then
        Error("The index exceeds the maximal index bound N = ", maxIndex, " of the algorithm!\n",
              "If you proceed, not all normal subgroups of index larger than N may be found.\n");
    fi;

    # Convert the group into an fp-group if possible.
    if not IsFpGroup(G) then
        Info(InfoLINS, 1, LINS_tab1,
            "Input group gets translated into an fp-group.");

        phi := IsomorphismFpGroup(G);
        G := Image(phi);
    fi;

    Info(InfoLINS, 1, LINS_tab1,
        "Initialize lins graph with group ", LINS_red, "G = ", G, LINS_reset, ".");

    gr := LinsGraph(G, n);
    gr!.Options := opts;
    opts.InitGraph(gr);

    if IsBound(phi) then
        gr!.Iso := phi;
    fi;

    # Search for possible T-Quotients
    Info(InfoLINS, 2, LINS_tab2,
        "Compute ", LINS_blue, "T-Quotients ", LINS_reset, "under ", LINS_red, "G", LINS_reset, ".");

    data := LINS_FindTQuotients(gr, opts);
    res := data[1];
    nrFound := data[2];

    Info(InfoLINS, 2, LINS_tab2,
        "Found ", LINS_red, nrFound, LINS_reset, " new normal subgroup(s).");

    if res then
        return gr;
    fi;

    # Compute all primes up to n
    primes := LINS_AllPrimesUpTo(n);
    i := 1;

    while i <= Length(gr!.Levels) do
        level := gr!.Levels[i];
        if level.Index > (n / 2) then
            break;
        fi;

        Info(InfoLINS, 1, LINS_tab1,
            "Index level ", LINS_red, level.Index, LINS_reset, " contains ",
            LINS_red, Length(level.Nodes), LINS_reset, " group(s).");

        for r in level.Nodes do
            Info(InfoLINS, 2, LINS_tab2,
                "Search under group ",
                LINS_red, "H = ", Grp(r), LINS_reset, ".");

            if opts.DoCut(gr, r) then
                Info(InfoLINS, 2, LINS_tab2,
                    "Cut branch under ", LINS_red, "H", LINS_reset, ".");

                r!.IsCut := true;
                continue;
            fi;

            # Search for possible P-Quotients
            Info(InfoLINS, 2, LINS_tab2,
                "Compute ", LINS_blue, "P-Quotients ", LINS_reset, "under ",
                LINS_red, "H", LINS_reset, ".");

            data := LINS_FindPQuotients(gr, r, primes, opts);
            res := data[1];
            nrFound := data[2];

            Info(InfoLINS, 2, LINS_tab2,
                "Found ", LINS_red, nrFound, LINS_reset, " new normal subgroup(s).");

            if res then
                return gr;
            fi;

            # Search for possible Intersections
            if i = 1 then
                continue;
            fi;

            Info(InfoLINS, 2, LINS_tab2,
                "Compute ", LINS_blue, "Intersections ", LINS_reset, "under ",
                LINS_red, "H", LINS_reset, ".");

            data := LINS_FindIntersections(gr, r, opts);
            res := data[1];
            nrFound := data[2];

            Info(InfoLINS, 2, LINS_tab2,
                "Found ", LINS_red, nrFound, LINS_reset, " new normal subgroup(s).");

            if res then
                return gr;
            fi;
        od;
        i := i + 1;
    od;

    if InfoLevel(InfoLINS) >= 1 then
        Info(InfoLINS, 1, LINS_tab1,
            "\033[1mTerminate search. Print remaining levels.\033[0m");

        for j in [i .. Length(gr!.Levels)] do
            level := gr!.Levels[j];
            Info(InfoLINS, 1, LINS_tab1,
                "Index level ", LINS_red, level.Index, LINS_reset, " contains ",
                LINS_red, Length(level.Nodes), LINS_reset, " group(s).");
        od;
    fi;

    # Return every normal subgroup
    return gr;
end);

# See documentation
InstallGlobalFunction( LowIndexNormalSubgroupsSearchForAll, function(G, n)
    return LowIndexNormalSubgroupsSearch(G, n);
end);

InstallMethod( LowIndexNormalSubs, "for groups",
               [IsGroup, IsPosInt],
function(G, n)
    local allSubgroups, gr, iso;
    allSubgroups := ValueOption("allSubgroups");
    if allSubgroups = fail then
        allSubgroups := true;
    fi;
    if allSubgroups then
        gr := LowIndexNormalSubgroupsSearchForAll(G, n);
    else
        gr := LowIndexNormalSubgroupsSearchForIndex(G, n, infinity);
    fi;
    iso := IsomorphismFpGroup(gr);
    return List(ComputedNormalSubgroups(gr), rH -> PreImage(iso, Grp(rH)));
end);
