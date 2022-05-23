#############################################################################
##  TestDihedral
#############################################################################
##  Description:
##
##  For integers `N`, `m` and `l`,
##  this tests the expected result on a search of
##  `l` normal subgroups of index `m` in the dihedral group D(2n)
##
##  The normal subgroups of D(2n) are classified as follows:
##  - 1. D(2n)
##  - 2. C(k) for k dividing n
##  - 3. if n is even, two times D(n)
#############################################################################

TestDihedral := function(N, m, l)
    local G, L, Current, n, k;
    if not IsEvenInt(N) then
        Error("Dihedral group has even size!");
    fi;
    n := N / 2;
    G := DihedralGroup(N);
    L := ComputedNormalSubgroups(LowIndexNormalSubgroupsSearchForIndex(G, m, l));

    if m = 2 then
        # two times D(n) and C(n/2)
        if IsEvenInt(n) then
            return Length(L) = Minimum(3, l);
        # C(n/2)
        else
            return Length(L) = Minimum(1, l);
        fi;
    elif m in DivisorsInt(n) then
        return Length(L) = Minimum(1, l);
    else
        return Length(L) = 0;
    fi;
end;
