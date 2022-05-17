# The normal subgroups of T^d = T_1 x ... x T_d are precisely 
# all the direct products that can be constructed 
# from set {T_1, ..., T_d}.
TestTProduct := function(T, d)
    local G, n, L, Current, k, l;
    G := DirectProduct(List([1 .. d], i -> T));
    n := Order(T) ^ d;
    L := List(LowIndexNormal(G, n));
    Current := 1;
    # k is number of factors
    for k in Reversed([1 .. d]) do
        # number of choices to choose k direct factors
        for l in [1 .. Binomial(d, k)] do
            if Order(L[Current]!.Grp) <> Order(T) ^ k then
                Error("LINS did not find enough copies of T^{", k, "}!");
            fi;
            Current := Current + 1;
        od;
    od;
    if Current <= Length(L) then
         Error("LINS found too many subgroups!");
    fi;
    return true;
end;
