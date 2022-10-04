#############################################################################
##  CompareResults
#############################################################################
##  Description:
##
##  This function compares the output of `LowIndexNormalSubgroupsSearch`
##  with a precomputed result from a previous run.
##
##  For a group `G`, an integer `n`, a correct index list `indexCor` and
##  a correct supergroups list `supersUnfilteredCor`, it construct a partial
##  lattice of normal subgroups of `G` up to `n` from this data
##  as well as from a `LowIndexNormalSubgroupsSearch` call.
##  Finally, it tests both graphs for isomorphism
##  with the GAP package "grape".
#############################################################################

CompareResults := function(G, n, indexCor, supersUnfilteredCor, UseLIS...)
    local L, path, index, supersUnfiltered, supers, supersCor, m, colour, gamma, gammaCor;

    if Length(UseLIS) > 1 then
        Error("Unknown number of arguments!");
    elif Length(UseLIS) = 1 then
        UseLIS := UseLIS[1];
    else
        UseLIS := false;
    fi;


    L := List(LowIndexNormalSubgroupsSearch(G, n, rec(DoSetParent := false, UseLIS := UseLIS)));

    # All groups have to be normal
    if ForAny(L, x -> not IsNormal(L[1]!.Grp, x!.Grp)) then
        Error("LINS found a subgroup that is not normal!");
    fi;

    # Compare the index lists
    index := List(L, x -> x!.Index);
    if index <> indexCor then
        Error("LINS index list differs from correct one!");
    fi;
    m := Length(index);

    supers := List(L, x -> List(x!.MinimalSupergroups, r -> Position(L, r)));
    supersCor := List(
        [1 .. m],
        x -> Filtered(
            supersUnfilteredCor[x],
            s -> ForAny(
                supersUnfilteredCor[x],
                t -> s in supersUnfilteredCor[t]) = false));

    # Compare the graph induced by subgroup relations
    # where the nodes of the graph are coloured by index
    colour := Set(List([1 .. m], i -> Filtered([1 .. m], j -> index[i] = index[j])));
    gamma := EdgeOrbitsGraph(
        Group( () ),
        Concatenation(List(
            [1 .. m],
            i -> List(supers[i], s->[s, i]))),
        m);
    gamma := rec(
        graph := gamma,
        colourClasses := colour);
    gammaCor := EdgeOrbitsGraph(
        Group( () ),
        Concatenation(List(
            [1 .. m],
            i -> List(supersCor[i], s -> [s, i]))),
        m);
    gammaCor := rec(
        graph := gammaCor,
        colourClasses := colour);

    if not IsIsomorphicGraph(gamma, gammaCor) then
        Error("LINS subgroup lattice differs from correct one!");
    fi;

    return true;
end;
