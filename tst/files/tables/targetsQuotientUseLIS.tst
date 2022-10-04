
gap> ReadPackage("LINS", "tst/gap/Tables/quotient.g");;
gap> n := 10000;;
gap> targets := targetsQuotient(LINS_TargetsQuotient_UseLIS, n);;

# Normal Table Computation
gap> targets2 := LINS_CreateTargetsQuotient(1, n, true);;
gap> targets = targets2;
true

# Parallelized Table Computation
gap> targetsList := [];;
gap> m := 10;;
gap> for k in [1 .. m] do
>      Add(targetsList, LINS_CreateTargetsQuotient(n/m * (k - 1), n/m * k, true));;
>    od;;
gap> targets3 := Concatenation(targetsList);;
gap> Sort(targets3);;
gap> targets = targets3;
true
