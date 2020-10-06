TestSemidirectProduct := function()
    local F, R, G, n, L, expected, primes, p, i, j, pos;
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


    n := 2000;
    n3 := Int(n / 3);
    L := LowIndexNormalSubgroups(G, n);

    # We enumerate all normal subgroups that we would expect to find from a theoratical point of view.
    # For this we track the positions in our list L of groups that we expected.
    # At the end the list expected should only contain true.
    expected := ListWithIdenticalEntries(Length(L), false);
    expected[1] := true;
    # We iterate though the primes smaller n.
    # For each prime we have a cerain subgraph or normal subgroups, that we would expect to find.
    # The subgraph begins in the lattice group L and each quotient has order p or p^2.
    # The missing expected groups are intersections of groups of the above subgraphs.
    primes := LINS_AllPrimesUpTo(n3);

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
    #                 3|--+--+--+
    #                  |  |  |  |
    #                  L  *  *  *
    #                  |  |  |  |
    #                 3|  |  |  |
    #                  |--+--+--+
    #                  *
    #                  |
    #                 3|
    #                  |
    #                 3 L
    #                  |
    #                 3|
    #                  |
    #                  *
    #                  |
    #                 3|
    #                  |
    #                 9 L
    #                  |
    #                  -
    #
    # Thus we expect to find exactly 4 normal subgroups of index 3, one of which is L.
    # Further the intersection of these 4 groups is a group of index 9.
    # Then we expect to find exactly one normal subgroup of index 3 * 3 ^ i.
    Remove(primes, 2);
    for i in [1 .. 4] do
        if L[1 + i]!.Index = 3 then
            expected[1 + i] := true;
        else
            return false;
        fi;
    od;
    for i in [1 .. LINS_MaxPowerSmallerInt(n3, 3)] do
        pos := PositionProperty(L, x -> x!.Index = 3 * 3 ^ i);
        if pos = fail then
            return false;
        else
            expected[pos] := true;
        fi;
    od;

    for p in primes do
        # In this case 3 | (p - 1), we expect to find the following subgraph:
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
            for i in [1 .. LINS_MaxPowerSmallerInt(n3, p)] do
                pos := PositionProperty(L, x -> x!.Index = 3 * p ^ i);
                if pos = fail then
                    Print("false");
                    return false;
                else
                    for j in [0 .. i] do
                        if L[pos + j]!.Index = 3 * p ^ i then
                            expected[pos + j] := true;
                        else
                            return false;
                            Print("false");
                        fi;
                    od;
                fi;
            od;
        # In this case 3 ∤ (p - 1), we expect to find the following subgraph:
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
        # Thus we expect to find exactly one group at index 3 * p ^ (2 * i)
        else
            for i in [1 .. LINS_MaxPowerSmallerInt(n3, p ^ 2)] do
                pos := PositionProperty(L, x -> x!.Index = 3 * p ^ (2 * i));
                if pos = fail or L[pos]!.Group <> Subgroup(G, [a ^ (p ^ i), b ^ (p ^ i)]) then
                    Print("false");
                    return false;
                else
                    expected[pos] := true;
                fi;
            od;
        fi;
    od;