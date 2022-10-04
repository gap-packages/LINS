
gap> n := 10000;;
gap> targets := Filtered(LINS_TargetsCharSimple, entry -> entry[1] <= n);;

# Normal Table Computation
gap> targets2 := LINS_CreateTargetsCharSimple(1, n);;
The Sylow p-subgroup of the group is cyclic - so the multiplier is trivial.
The Sylow p-subgroup of the group is cyclic - so the multiplier is trivial.
The Sylow p-subgroup of the group is cyclic - so the multiplier is trivial.
The Sylow p-subgroup of the group is cyclic - so the multiplier is trivial.
The Sylow p-subgroup of the group is cyclic - so the multiplier is trivial.
The Sylow p-subgroup of the group is cyclic - so the multiplier is trivial.
The Sylow p-subgroup of the group is cyclic - so the multiplier is trivial.
The Sylow p-subgroup of the group is cyclic - so the multiplier is trivial.
The Sylow p-subgroup of the group is cyclic - so the multiplier is trivial.
The Sylow p-subgroup of the group is cyclic - so the multiplier is trivial.
The Sylow p-subgroup of the group is cyclic - so the multiplier is trivial.
The Sylow p-subgroup of the group is cyclic - so the multiplier is trivial.
The Sylow p-subgroup of the group is cyclic - so the multiplier is trivial.
The Sylow p-subgroup of the group is cyclic - so the multiplier is trivial.
The Sylow p-subgroup of the group is cyclic - so the multiplier is trivial.
The Sylow p-subgroup of the group is cyclic - so the multiplier is trivial.
The Sylow p-subgroup of the group is cyclic - so the multiplier is trivial.
The Sylow p-subgroup of the group is cyclic - so the multiplier is trivial.
The Sylow p-subgroup of the group is cyclic - so the multiplier is trivial.
The Sylow p-subgroup of the group is cyclic - so the multiplier is trivial.
The Sylow p-subgroup of the group is cyclic - so the multiplier is trivial.
The Sylow p-subgroup of the group is cyclic - so the multiplier is trivial.
The Sylow p-subgroup of the group is cyclic - so the multiplier is trivial.
The Sylow p-subgroup of the group is cyclic - so the multiplier is trivial.
The Sylow p-subgroup of the group is cyclic - so the multiplier is trivial.
The Sylow p-subgroup of the group is cyclic - so the multiplier is trivial.
The Sylow p-subgroup of the group is cyclic - so the multiplier is trivial.
The Sylow p-subgroup of the group is cyclic - so the multiplier is trivial.
The Sylow p-subgroup of the group is cyclic - so the multiplier is trivial.
The Sylow p-subgroup of the group is cyclic - so the multiplier is trivial.
The Sylow p-subgroup of the group is cyclic - so the multiplier is trivial.
The Sylow p-subgroup of the group is cyclic - so the multiplier is trivial.
The Sylow p-subgroup of the group is cyclic - so the multiplier is trivial.
The Sylow p-subgroup of the group is cyclic - so the multiplier is trivial.
gap> targets = targets2;
true

# Parallelized Table Computation
gap> targetsList := [];;
gap> m := 10;;
gap> for k in [1 .. m] do
>      Add(targetsList, LINS_CreateTargetsCharSimple(n/m * (k - 1), n/m * k));;
>    od;;
The Sylow p-subgroup of the group is cyclic - so the multiplier is trivial.
The Sylow p-subgroup of the group is cyclic - so the multiplier is trivial.
The Sylow p-subgroup of the group is cyclic - so the multiplier is trivial.
The Sylow p-subgroup of the group is cyclic - so the multiplier is trivial.
The Sylow p-subgroup of the group is cyclic - so the multiplier is trivial.
The Sylow p-subgroup of the group is cyclic - so the multiplier is trivial.
The Sylow p-subgroup of the group is cyclic - so the multiplier is trivial.
The Sylow p-subgroup of the group is cyclic - so the multiplier is trivial.
The Sylow p-subgroup of the group is cyclic - so the multiplier is trivial.
The Sylow p-subgroup of the group is cyclic - so the multiplier is trivial.
The Sylow p-subgroup of the group is cyclic - so the multiplier is trivial.
The Sylow p-subgroup of the group is cyclic - so the multiplier is trivial.
The Sylow p-subgroup of the group is cyclic - so the multiplier is trivial.
The Sylow p-subgroup of the group is cyclic - so the multiplier is trivial.
The Sylow p-subgroup of the group is cyclic - so the multiplier is trivial.
The Sylow p-subgroup of the group is cyclic - so the multiplier is trivial.
The Sylow p-subgroup of the group is cyclic - so the multiplier is trivial.
The Sylow p-subgroup of the group is cyclic - so the multiplier is trivial.
The Sylow p-subgroup of the group is cyclic - so the multiplier is trivial.
The Sylow p-subgroup of the group is cyclic - so the multiplier is trivial.
The Sylow p-subgroup of the group is cyclic - so the multiplier is trivial.
The Sylow p-subgroup of the group is cyclic - so the multiplier is trivial.
The Sylow p-subgroup of the group is cyclic - so the multiplier is trivial.
The Sylow p-subgroup of the group is cyclic - so the multiplier is trivial.
The Sylow p-subgroup of the group is cyclic - so the multiplier is trivial.
The Sylow p-subgroup of the group is cyclic - so the multiplier is trivial.
The Sylow p-subgroup of the group is cyclic - so the multiplier is trivial.
The Sylow p-subgroup of the group is cyclic - so the multiplier is trivial.
The Sylow p-subgroup of the group is cyclic - so the multiplier is trivial.
The Sylow p-subgroup of the group is cyclic - so the multiplier is trivial.
The Sylow p-subgroup of the group is cyclic - so the multiplier is trivial.
The Sylow p-subgroup of the group is cyclic - so the multiplier is trivial.
The Sylow p-subgroup of the group is cyclic - so the multiplier is trivial.
The Sylow p-subgroup of the group is cyclic - so the multiplier is trivial.
The Sylow p-subgroup of the group is cyclic - so the multiplier is trivial.
The Sylow p-subgroup of the group is cyclic - so the multiplier is trivial.
gap> targets3 := Concatenation(targetsList);;
gap> Sort(targets3);;
gap> targets = targets3;
true
