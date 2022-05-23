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
##  For integer `n` and `l`,
##  this tests the expected result on a search of
##  `l` normal subgroups of index `m` in the semidirect product
##
##                          $G = Z ^ 2 ><| C_3$.
##
##  The normal subgroups of $G$ are described below in the comments.
#############################################################################
TestSemidirectProduct := function(n, l)
    local F, R, G, a, b, c, n3, gr, L, p, i, pos, index, factors, nrFactors, pos3, nrSubgroups;
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
    gr := LowIndexNormalSubgroupsSearchForIndex(G, n, l);
    L := ComputedNormalSubgroups(gr);

    factors := PrimePowersInt(n);
    nrFactors := Length(factors) / 2;

    pos3 := PositionProperty([1 .. nrFactors], i -> factors[2 * (i - 1) + 1] = 3);
    if pos3 = fail then
        return Length(L) = 0;
    fi;

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
    p := factors[2 * (pos3 - 1) + 1];
    i := factors[2 * pos3];
    if i = 1 then
        nrSubgroups := 4;
    else
        nrSubgroups := 1;
    fi;
    if nrFactors = 1 then
        return Length(L) = Minimum(nrSubgroups, l);
    else
        nrSubgroups := 1;
    fi;

    for pos in List([1 .. nrFactors]) do
        if pos = pos3 then
            continue;
        fi;
        p := factors[2 * (pos - 1) + 1];
        i := factors[2 * pos];
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
            nrSubgroups := nrSubgroups * (i + 1);
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
            if RemInt(i, 2) <> 0 then
                return Length(L) = 0;
            fi;
        fi;
    od;

    return Length(L) = Minimum(nrSubgroups, l);
end;
