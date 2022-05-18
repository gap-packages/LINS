#############################################################################
##  findPQuotients.gi
#############################################################################
##
##  This file is part of the LINS package.
##
##  This file's authors include Friedrich Rober.
##
##  Please refer to the COPYRIGHT file for details.
##
##  SPDX-License-Identifier: GPL-2.0-or-later
##
#############################################################################

#############################################################################
## This finds the sizes of the minimal normal subgroups of
## G/H, where H is the group in the position Current in the list.
#############################################################################

BindGlobal("LINS_MinSubgroupSizes", function(rH)
  	return List(MinimalSupergroups(rH), rK -> Index(rH) / Index(rK) );
end);


#############################################################################
## For positive integers a,b
## return true if a is some power of b;
#############################################################################
BindGlobal("LINS_IsPowerOf", function(a, b)
	local c;

	c := a;
	while c > 1 do
		if c mod b = 0 then
			c := QuoInt(c,b);
		else
			return false;
		fi;
	od;

	return true;
end);


#############################################################################
## This function returns the size of the group GL(r,p).
#############################################################################

BindGlobal("LINS_OGL", function(r, p)
  	local i,j;

  	i := 1;
	for j in [0..(r-1)] do
		i := i * (p^r - p^j);
	od;

	return i;
end);


#############################################################################
## This function checks if p-Quotients have to be computed.
## Otherwise the groups can be expressed as Intersections of bigger groups.
## n is the maximal index, p a prime, index is the index of some group H
## and minSubSizes are the sizes computed by a call of LINS_MinSubgroupSizes on H.
#############################################################################

InstallGlobalFunction(LINS_MustCheckP, function(n, p, index, minSubSizes)
	local i,j, ordersToCheck, r;

	for i in minSubSizes do
		if LINS_IsPowerOf(i, p) then
			return false;
		fi;
	od;

	# orders of Characteristically Simple Groups, where p is a divisor of the order of the schur multiplier
	ordersToCheck := List( Filtered(LINS_TargetsCharSimple, Q -> p in Q[2]), Q -> Q[1]);
	for i in minSubSizes do
		for j in ordersToCheck do
			if i = j then
				return true;
			fi;
		od;
	od;

	r := 1;
	while p^(r+1) <= n / index do
		r := r+1;
	od;

	if LINS_OGL(r, p) mod index = 0 then
		return true;
	fi;

	return false;
end);


#############################################################################
## Calculate the exponent sum n-size vector of word in Fp
#############################################################################

BindGlobal("LINS_ExponentSum", function(n,p,word)
	local
	rep,      # exponent Representaton of word, that are tupels (a,b), such that a^b is a subword of word
	i,        # loop variable
	res;      # exponent sum n-size vector of word

	i := 1;
	res := List([1 .. n], x -> 0);
	rep := ExtRepOfObj(word);
	while Length(rep) >= 2 * i do
		res[rep[2 * i - 1]] := rep[2 * i];
		i := i + 1;
	od;

	return List(res, x -> x * MultiplicativeNeutralElement(FiniteField(p)));
end);


#############################################################################
## Calculate the GroupHomomorphism into the symmetric group
## representing the action of H on H/K by multiplication
#############################################################################

BindGlobal("LINS_PullBackH", function(GenM, p, Gens, O, Mu, Psi)
  	return List(
		[1 .. Length(Gens)],
	  	i -> PermList(List(
			[1 .. Length(O)],
			j -> Position(O, O[j] + (LINS_ExponentSum(Length(GenM), p, Gens[i] ^ Mu)) ^ Psi))));
end);


#############################################################################
## maximal Generators of the PQuotient.
#############################################################################

BindGlobal("LINS_maxPGenerators", 1000);


#############################################################################
## Let the group G be located in the root of gr.
## Let the group H be located in the node rH.
## Calculate every normal subgroup K of G, such that H/K is a p-Group
## and the index in G is less equal n.
##
## We construct a module over the groupring (F_p G) and compute maximal submodules of this module.
## These submodules can be translated into the subgroups of H we are searching for, namely elementary abelian p-Quotients.
## Then we call the method on the found subgroups so we compute all p-Quotients and not only the elementary abelian ones.
#############################################################################

InstallGlobalFunction(LINS_FindPModules, function(gr, rH, p, opts)
	local
	G,        # the parent group, which is stored in the root of gr
	n,        # index bound
	H,        # the current group, contained in node rH
	Iso,      # isomorphism from H into fp-group
	IH,       # fp-group, image of Iso
	P,        # p-quotient of IH of class 1
	Mu,       # epimorphism from IH into P
	M,        # pc-group, image of Mu
	GenM,     # generators of M, basis of Fp-G module M
	gens,     # list of matrices, action of generators of G on M
	x,        # loop variable, generator of G
	y,        # loop variable, generator of M identified by Mu and Iso with word in H
	word,     # word in M, y^x via a "conjugation" action of G on M
	gen,      # Fp-matrix, action of some generator of G on M
	GM,       # MeatAxe module, representation of Fp-G module M by gens
	MM,       # list of maximal modules of GM
	m,        # loop variable, maximal module
	V,        # Vectorspace Fp^n, where n is the dimension of GM
	r,        # index of m in V, which equals index of K in H
	PsiHom,   # epimorphism from V to V/m
	Q,        # vector space, image of PsiHom
	O,        # elements of Q
	GenIH,    # generators of IH
	PhiHom,   # epimorphism from H into p-quotient H/K, identification of Q as a quotient of H via Mu
	K,        # subgroup of H with p-quotient, normal in G
	rK,       # node containing K
	NewGroup; # record (list, position) after inserting K into GroupsFound

	# Check if p-Quotients have been computed already from this group
	if p in TriedPrimes(rH) then
		return;
	fi;
	AddSet(TriedPrimes(rH), p);

	# Initialize data
	n := IndexBound(gr);
	G :=Grp(Root(gr));
	H := Grp(rH);

	# Isomorphism onto the fp-group of H
	Iso := IsomorphismFpGroup(H);
	IH := Image(Iso);

	# Create the Isomorphism to the group structure of the p-Module M
	P := PQuotient(IH, p, 1, LINS_maxPGenerators);
	Mu := EpimorphismQuotientSystem(P);
	M := Image(Mu);
	GenM := GeneratorsOfGroup(M);

	# If M is trivial we skip this prime
	if IsEmpty(GenM) then
		return;
	fi;

	# Define the group action of G on the p-Module M
	# For every generator in G we store the action on M in form of a Matrix
	gens := [];
	for x in GeneratorsOfGroup(G) do
		gen := [];
		for y in GenM do
			y := PreImagesRepresentative(Iso, PreImagesRepresentative(Mu, y));
			word := Image(Mu, Image(Iso, x * y * x ^ (-1) ));
			Add(gen, LINS_ExponentSum(Length(GenM), p, word));
		od;
		Add(gens, gen);
	od;

	# Calculate the maximal submodules of M
	GM := GModuleByMats(gens, FiniteField(p));
	MM := MTX.BasesMaximalSubmodules(GM);
	V := FiniteField(p) ^ (Length(GenM));

	# Translate every submodule of M into a normal subgroup of H with elementary abelian p-Quotient
	for m in MM do

		# Check wether the index will be greater than n
		m := Subspace(V, m);
		r := p ^ ( Dimension(V) - Dimension(m) );
		if r > n / Index(G, H) then
			continue;
		fi;

		# Calculate the natural homomorphism from V to V/m
		PsiHom := NaturalHomomorphismBySubspace(V, m);
		Q := Image(PsiHom);
		O := Elements(Q);
		GenIH := GeneratorsOfGroup(IH);

		# Calculate the subgroup K with H/K being an elementary abelian p-Group
		PhiHom :=  GroupHomomorphismByImagesNC(H, SymmetricGroup(Length(O)),
			LINS_PullBackH(GenM, p, List(GeneratorsOfGroup(H), x->Image(Iso, x)), O, Mu, PsiHom));

		K := Kernel(PhiHom);
		if opts.DoSetParent then
			LINS_SetParent(K, G);
		fi;

		# Add the subgroup K by calling the LINS_AddGroup-function
		if Index(G, K) <= n then
			rK := LINS_AddGroup(gr, K, [rH], true, opts);
			# If the index is sufficient small, compute p-Quotients from the subgroup K
			if p <= n / Index(G, K) then
				LINS_FindPModules(gr, rK, p, opts);
			fi;
		fi;
	od;
end);

#############################################################################
## Let the group G be located in the list GroupsFound at position 1.
## Let the group H be located in the list GroupsFound at position Current.
## Calculate every normal subgroup K of G, such that H/K is a p-Group
## and the index in G is less equal n.
#############################################################################

InstallGlobalFunction(LINS_FindPQuotients, function(gr, rH, primes, opts)
	local
	G,      # the parent group, which is stored at the first position in GroupsFound
	n,		# index bound
	H,      # the group (record) at position Current
	p;      # loop variable, prime integer

	# References to the Groups in the list GroupsFound.
	G := Grp(Root(gr));
	n := IndexBound(gr);
	H := Grp(rH);

	# Search for p-Quotients for every prime small enough.
	for p in primes do
		if p > n / Index(rH) then
			break;
		fi;
		# Check according to some rules whether the p-Quotients will be computed by Intersections.
		if( LINS_MustCheckP(n, p, Index(rH), LINS_MinSubgroupSizes(rH)) ) then
			# Compute all p-Groups from H.
			LINS_FindPModules(gr, rH, p, opts);
		fi;
	od;
end);
