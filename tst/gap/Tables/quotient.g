targetsQuotient := function(targets, n)
    local names, sizes;

    names := Set(List(targets, entry -> entry[3]));
    sizes := List(names, T -> Minimum(List(Filtered(targets, entry -> entry[3] = T), entry -> entry[1])));
    names := names{Filtered([1 .. Length(names)], i -> sizes[i] <= n)};
    return Filtered(targets, entry -> entry[3] in names);
end;

AreTablesEqual := function(A, B)
    local namesA, namesB, T, filteredA, filteredB, sizesA, sizesB, s, fA, fB, n, pi, foundPerm, i, G, H;

    if Length(A) <> Length(B) then
        return false;
    fi;

    namesA := Set(List(A, entry -> entry[3]));
    namesB := Set(List(B, entry -> entry[3]));

    if namesA <> namesB then
        return false;
    fi;

    for T in namesA do
        filteredA := Filtered(A, entry -> entry[3] = T);
        filteredB := Filtered(B, entry -> entry[3] = T);
        sizesA := List(filteredA, entry -> entry[1]);
        sizesB := List(filteredB, entry -> entry[1]);

        if sizesA <> sizesB then
            return false;
        fi;

        for s in Set(sizesA) do
            fA := Filtered(filteredA, entry -> entry[1] = s);
            fB := Filtered(filteredB, entry -> entry[1] = s);
            n := Size(fA);
            foundPerm := false;
            for pi in SymmetricGroup(n) do
                foundPerm := true;
                for i in [1 .. n] do
                    G := fA[i][2];
                    H := fB[i ^ pi][2];
                    if G <> H and IsomorphismGroups(G, H) = fail then
                        foundPerm := false;
                        break;
                    fi;
                od;

                if foundPerm then
                    break;
                fi;
            od;

            if not foundPerm then
                return false;
            fi;
        od;
    od;

    return true;

end;
