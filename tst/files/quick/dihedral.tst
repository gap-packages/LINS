gap> # The normal subgroups of D(2n) are classified as follows
gap> # 1. D(2n)
gap> # 2. C(k) for k dividing n
gap> # 3. if n is even, two times D(n)
gap> TestDihedral := function(n)
>     local G,L,Current,k;
>     G := DihedralGroup(2*n);
>     L := LowIndexNormal(G,2*n);
>     Current := 2;
>     if IsEvenInt(n) then
>         for k in [1..2] do
>             if Order(L[Current].Group) <> n then
>                 return false;
>             fi;
>             Current := Current + 1;
>         od;
>     fi;
>     for k in Reversed(DivisorsInt(n)) do
>         if Order(L[Current].Group) <> k then
>                 return false;
>         fi;
>         Current := Current + 1;
>     od;
>     return true;
> end;;
gap> TestDihedral(100);
true
gap> TestDihedral(500);
true
gap> 
