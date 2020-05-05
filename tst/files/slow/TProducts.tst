gap> # The normal subgroups of T^d = T_1 x ... x T_d are precisely 
gap> # all the direct products that can be constructed 
gap> # from set {T_1, ..., T_d}.
gap> TestTProduct := function(T, d)
>     local G,n,L,Current,k,l;
>     G := DirectProduct(List([1..d], i -> T));
>     n := Order(T)^d;
>     L := LowIndexNormal(G,n);
>     Current := 1;
>     # k is number of factors
>     for k in Reversed([1..d]) do
>         # number of choices to choose k direct factors
>         for l in [1..Binomial(d,k)] do
>             if Order(L[Current].Group) <> Order(T)^k then
>                 return false;
>             fi;
>             Current := Current + 1;
>         od;
>     od;
>     return true;
> end;;
gap> T := Image(IsomorphismFpGroup(SimpleGroup("A5")));;
gap> d := 2;;
gap> TestTProduct(T,d);
true
gap> 
