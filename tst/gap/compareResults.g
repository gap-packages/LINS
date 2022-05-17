# This compares the output of LowIndexNormal with a precomputed result.
# The precomputed result was created by LowIndexNormal in the past.
CompareResults := function(G, n, indexCor, supersUnfilteredCor)
    local L, path, index, supersUnfiltered, supers, supersCor, m, colour, gamma, gammaCor;

    L := List(LowIndexNormal(G, n, rec(DoSetParent := false)));

    # All groups have to be normal
    if ForAny(L, x -> not IsNormal(L[1]!.Grp, x!.Grp)) then
        return false;
    fi;

    # Compare the index lists
    index := List(L, x -> x!.Index);
    if index <> indexCor then
        return false;
    fi;
    m := Length(index);

    supersUnfiltered := List(L, x -> List(x!.MinimalSupergroups, r -> Position(L, r)));
    supers := List(
        [1 .. m],
        x -> Filtered(
            supersUnfiltered[x],
            s -> ForAny(
                supersUnfiltered[x],
                t -> s in supersUnfiltered[t]) = false));
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
    return IsIsomorphicGraph(gamma, gammaCor);
end;
