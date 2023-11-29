#############################################################################
##  MaxPowerSmallerInt
#############################################################################
##  Description:
##
##  For integers `n` and `a`,
##  this returns the maximal integer `i`, such that $a ^ i <= n$.
##
#############################################################################

MaxPowerSmallerInt := function(n, a)
    local i, j;
    i := 0;
    j := 1;
    while a ^ j <= n do
        i := j;
        j := j + 1;
    od;
    return i;
end;


#############################################################################
##  TestSemidirectProduct
#############################################################################
##  Description:
##
##  For an integer `n`,
##  this tests the normal subgroups of the semidirect product
##
##                          $G = Z ^ 2 ><| C_3$
##
##  up to index `n`.
##
##  The normal subgroups of $G$ are described below in the comments.
#############################################################################
TestSemidirectProduct := function(n)
    local F, R, G, a, b, c, n3, gr, L, expected, subgraphs, subgraph, primes, p, i, j, pos, nrIntersections, iterSubgraphs, iterSubgroups, subgraphSelection, subgroupSelection, minIndex, index;
    # <a, b> = Z ^ 2 and <c> = C_3
    # c := [ [ 0, -1 ], [ 1, -1 ] ];
    # c in GL(2, Z) and |c| = 3
    # Semidirect Product via Left-Action of <c> on Z ^ 2
    F := FreeGroup(["a", "b", "c"]);
    a := F.1;
    b := F.2;
    c := F.3;
    R := [Comm(a, b), c ^ 3, (a ^ c) ^ (-1) * b, (b ^ c) ^ (-1) * a ^ (-1) * b ^ (-1)];
    G := F/R;
    a := G.1;
    b := G.2;
    c := G.3;

    n3 := Int(n / 3);
    gr := LowIndexNormalSubgroupsSearch(G, n);
    L := List(gr);

    # We enumerate all normal subgroups that we would expect to find from a theoratical point of view.
    # For this we track the positions in our list L of groups that we expected.
    # At the end the list expected should only contain true.
    expected := ListWithIdenticalEntries(Length(L), false);
    expected[1] := true;
    # We iterate though the primes smaller n/3.
    # For each prime we have a cerain subgraph of normal subgroups, that we would expect to find.
    # The subgraph begins in the lattice group L and each quotient has order p or p^2.
    # The missing expected groups are exactly the intersections of groups of the above subgraphs.
    primes := LINS_AllPrimesUpTo(n3);
    subgraphs := [];

    # For p = 3, we expect to find the following subgraph:
    #
    # Legend:
    # L is the lattice group i.e. the additive group Z^2.
    # An asterisk (*) denotes a vertex without name i.e. a normal subgroup.
    # Vertical Line Segments denote edges, i.e. subgroup relations.
    # Horizontal Line Segments help to visualize if two vertices are on the same level, i.e. have equal index.
    # The index between groups is denoted on the side of the edges.
    #
    #                  G
    #                  |
    #                3 |--+--+--+
    #                  |  |  |  |
    #                  L  *  *  *
    #                  |  |  |  |
    #                3 |--+--+--+
    #                  |
    #                  *
    #                  |
    #                3 |
    #                  |
    #                3^1 L
    #                  |
    #                3 |
    #                  |
    #                  *
    #                  |
    #                3 |
    #                  |
    #                3^2 L
    #                  |
    #                  -
    #
    # Thus we expect to find exactly 4 normal subgroups of index 3, one of which is L.
    # Further the intersection of these 4 groups is a group of index 9.
    # Then we expect to find exactly one normal subgroup of index 3 * 3 ^ i.
    Remove(primes, 2); # remove 3 from primes
    subgraph := [];
    for i in [1 .. 4] do
        if L[1 + i]!.Index = 3 then
            if expected[1 + i] = true then
                Error("Subgroup has already been visited. This is unexpected!");
            fi;
            expected[1 + i] := true;
        else
            Error("LINS did not find 3-quotient subgroup of index ", 3);
        fi;
    od;
    for i in [1 .. MaxPowerSmallerInt(n3, 3)] do
        pos := PositionProperty(L, x -> x!.Index = 3 * 3 ^ i);
        if pos = fail then
            Error("LINS did not find 3-quotient subgroup of index ", 3 * 3 ^ i);
        elif IsEvenInt(i) and L[pos]!.Grp <> Subgroup(G, [a ^ (3 ^ (i/2)), b ^ (3 ^ (i/2))]) then
            Error("LINS did not find correct 3-quotient subgroup of index ", 3 * 3 ^ i);
        else
            if expected[pos] = true then
                Error("Subgroup has already been visited. This is unexpected!");
            fi;
            expected[pos] := true;
            Add(subgraph, pos);
        fi;
    od;
    Add(subgraphs, subgraph);

    for p in primes do
        subgraph := [];
        # In the case 3 | (p - 1), we expect to find the following subgraph:
        #
        # Legend:
        # L is the lattice group i.e. the additive group Z ^ 2.
        # An asterisk (*) denotes a vertex without name i.e. a normal subgroup.
        # Vertical Line Segments denote edges, i.e. subgroup relations.
        # Horizontal Line Segments help to visualize if two vertices are on the same level, i.e. have equal index.
        # The index between groups is denoted on the side of the edges.
        #
        #                  G
        #                  |
        #                3 |
        #                  |
        #                  L
        #                 / \
        #              p /   \ p
        #               /     \
        #              *-------*
        #             / \     / \
        #          p /   \   /   \ p
        #           /     \ /     \
        #          *-------*-------*
        #         / \     / \     / \
        #      p /   \   /   \   /   \ p
        #       /     \ /     \ /     \
        #      *-------*-------*-------*
        #     /       / \     / \       \
        #    -       -   -   -   -       -
        #
        # Thus we expect to find exactly (i + 1) normal subgroups of index (3 * p ^ i).
        if RemInt(p - 1, 3) = 0 then
            for i in [1 .. MaxPowerSmallerInt(n3, p)] do
                pos := PositionProperty(L, x -> x!.Index = 3 * p ^ i);
                if pos = fail then
                    Error("LINS did not find any ", p, "-quotient subgroup of index ", 3 * p ^ i);
                else
                    for j in [0 .. i] do
                        if L[pos + j]!.Index = 3 * p ^ i then
                            if expected[pos + j] = true then
                                Error("Subgroup has already been visited. This is unexpected!");
                            fi;
                            expected[pos + j] := true;
                            Add(subgraph, pos + j);
                        else
                            Error("LINS did not find enough ", p, "-quotient subgroups of index ", 3 * p ^ i);
                        fi;
                    od;
                fi;
            od;
        # In the case 3 ∤ (p - 1), we expect to find the following subgraph:
        #
        # Legend:
        # L is the lattice group i.e. the additive group Z^2.
        # An asterisk (*) denotes a vertex without name i.e. a normal subgroup.
        # Vertical Line Segments denote edges, i.e. subgroup relations.
        # Horizontal Line Segments help to visualize if two vertices are on the same level, i.e. have equal index.
        # The index between groups is denoted on the side of the edges.
        #
        #                  G
        #                  |
        #                3 |
        #                  |
        #                  L
        #                  |
        #              p^2 |
        #                  |
        #                p^1 L
        #                  |
        #              p^2 |
        #                  |
        #                p^2 L
        #                  |
        #              p^2 |
        #                  |
        #                p^3 L
        #                  |
        #                  -
        #
        # Thus we expect to find exactly one group of index 3 * p ^ (2 * i)
        else
            for i in [1 .. MaxPowerSmallerInt(n3, p ^ 2)] do
                pos := PositionProperty(L, x -> x!.Index = 3 * p ^ (2 * i));
                if pos = fail or L[pos]!.Grp <> Subgroup(G, [a ^ (p ^ i), b ^ (p ^ i)]) then
                    Error("LINS did not find ", p, "-quotient subgroup of index ", 3 * p ^ (2 * i));
                else
                    if expected[pos] = true then
                        Error("Subgroup has already been visited. This is unexpected!");
                    fi;
                    expected[pos] := true;
                    Add(subgraph, pos);
                fi;
            od;
        fi;
        Add(subgraphs, subgraph);
    od;

    # Remove every empty subgraph
    pos := Position(subgraphs, []);
    while pos <> fail do
        Remove(subgraphs, pos);
        pos := Position(subgraphs, []);
    od;

    # Sort by smallest index of subgraph
    SortBy(subgraphs, subgraph -> L[subgraph[1]]!.Index);

    # The intersections of the subgroups in subgraphs are the missing normal subgroups
    for nrIntersections in [2 .. Length(subgraphs)] do
        iterSubgraphs := EmptyPlist(nrIntersections);
        iterSubgraphs[1] := Iterator([1 .. Length(subgraphs)]);
        subgraphSelection := EmptyPlist(nrIntersections);
        minIndex := EmptyPlist(nrIntersections + 1); # shift by 1 to the right
        minIndex[1] := 3;
        i := 1;
        while i > 0 do
            if IsDoneIterator(iterSubgraphs[i]) then
                Unbind(iterSubgraphs[i]);
                Unbind(subgraphSelection[i]);
                Unbind(minIndex[i + 1]);
                i := i - 1;
                continue;
            fi;
            subgraphSelection[i] := NextIterator(iterSubgraphs[i]);
            minIndex[i + 1] := minIndex[i] * L[subgraphs[subgraphSelection[i]][1]]!.Index / 3;
            if minIndex[i + 1] > n then
                Unbind(iterSubgraphs[i]);
                Unbind(subgraphSelection[i]);
                Unbind(minIndex[i + 1]);
                i := i - 1;
                continue;
            fi;
            if i < nrIntersections then
                iterSubgraphs[i + 1] := Iterator([subgraphSelection[i] + 1 .. Length(subgraphs)]);
                i := i + 1;
                continue;
            fi;
            # i = nrIntersection and minIndex[i + 1] <= n
            iterSubgroups := List(subgraphSelection, k -> Iterator(subgraphs[k]));
            subgroupSelection := EmptyPlist(nrIntersections);
            j := 1;
            while j > 0 do
                if IsDoneIterator(iterSubgroups[j]) then
                    iterSubgroups[j] := Iterator(subgraphs[subgraphSelection[j]]);
                    Unbind(subgroupSelection[j]);
                    j := j - 1;
                    continue;
                fi;
                subgroupSelection[j] := NextIterator(iterSubgroups[j]);
                if j < nrIntersections then
                    j := j + 1;
                    continue;
                fi;
                # index of intersection
                index := 3 * Product(subgroupSelection, i -> L[i]!.Index / 3);
                if index > n then
                    iterSubgroups[j] := Iterator(subgraphs[subgraphSelection[j]]);
                    Unbind(subgroupSelection[j]);
                    j := j - 1;
                    continue;
                fi;
                # pos of intersection
                pos := PositionProperty(L, x -> Index(x) = index and ForAll(subgroupSelection, i -> L[i] in LinsNodeSupergroups(x)));
                if pos = fail then
                    Error("LINS did not find intersection of the subgroups with index list ", List(subgroupSelection, L[i]!.Index));
                else
                    if expected[pos] = true then
                        Error("Subgroup has already been visited. This is unexpected!");
                    fi;
                    expected[pos] := true;
                fi;
            od;
        od;
    od;

    if ForAny(expected, value -> value = false) then
        Error("LINS found too many subgroups!");
    fi;

    return true;
end;
