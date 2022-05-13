# The normal subgroups of D(2n) are classified as follows
# 1. D(2n)
# 2. C(k) for k dividing n
# 3. if n is even, two times D(n)
TestDihedral := function(N)
    local G,L,Current,n,k;
    if not IsEvenInt(N) then
        Error("Dihedral group has even size!");
    fi;
    n := N / 2;
    G := DihedralGroup(N);
    L := List(LowIndexNormal(G, N));
    Current := 2;
    if IsEvenInt(n) then
        for k in [1 .. 2] do
            if Order(L[Current]!.Grp) <> n then
                return false;
            fi;
            Current := Current + 1;
        od;
    fi;
    for k in Reversed(DivisorsInt(n)) do
        if Order(L[Current]!.Grp) <> k then
                return false;
        fi;
        Current := Current + 1;
    od;
    if Current <= Length(L) then
        return false;
    fi;
    return true;
end;
