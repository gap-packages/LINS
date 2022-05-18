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
##  LINS_IsPowerOf
#############################################################################
##  Description:
##
##  For positive integers `a` and `b`
##  returns true if `a` is some power of `b`;
#############################################################################
BindGlobal("LINS_IsPowerOf", function(a, b)
	local c;

	c := a;
	while c > 1 do
		if c mod b = 0 then
			c := QuoInt(c, b);
		else
			return false;
		fi;
	od;

	return true;
end);


#############################################################################
##  LINS_OGL
#############################################################################
##  Description:
##
##  For a positive integer `s` and a prime `p`,
##  returns the size of the group $GL(s, p)$.
#############################################################################

BindGlobal("LINS_OGL", function(s, p)
  	local i, j;

  	i := 1;
	for j in [0 .. (s - 1)] do
		i := i * (p ^ s - p ^ j);
	od;

	return i;
end);


#############################################################################
##  LINS_MustCheckP
#############################################################################
##  Input:
##
##  - rH : 		LINS node in a LINS graph gr
##  - n  : 		index bound
##  - p  :		prime
#############################################################################
##  Usage:
##
##  The function `LINS_FindPQuotients` calls this function.
#############################################################################
##  Description:
##
##  Returns true if `p`-quotients need to be computed explicitly.
##  Otherwise the groups can be expressed as intersections of larger groups.
#############################################################################

InstallGlobalFunction(LINS_MustCheckP, function(rH, n, p)
	local index, minSubSizes, i, j, ordersToCheck, s;

	# Let the group $G$ be located in the root node of the LINS graph `gr`.
	# Let the group $H$ be located in the node `rH`.

	# $[G : H]$
	index := Index(rH);

	# sizes of minimal normal subgroups of $G/H$
	minSubSizes := List(MinimalSupergroups(rH), rK -> Index(rH) / Index(rK));

	# Has the quotient G/H a non-trivial normal `p`-subgroup?
	# If yes, then do not compute `p`-quotients under $H$.
	for i in minSubSizes do
		if LINS_IsPowerOf(i, p) then
			return false;
		fi;
	od;

	# orders of characteristically simple groups,
	# where `p` is a divisor of the order of the schur multiplier.
	ordersToCheck := List(Filtered(LINS_TargetsCharSimple, Q -> p in Q[2]), Q -> Q[1]);

	# Has the quotient $G/H$ a minimal normal subgroup isomorphic to $T ^ d$,
	# where $T$ is non abelian simple and `p` divides $|Mult(T)|$?
	# If yes, then compute p-quotients under $H$.
	for i in minSubSizes do
		for j in ordersToCheck do
			if i = j then
				return true;
			fi;
		od;
	od;

	# maximal integer $s$ such that $[G : H] * p ^ s <= n$
	s := 1;
	while p ^ (s + 1) <= n / index do
		s := s + 1;
	od;

	# Does $[G : H]$ divide $|GL(s, p)|$?
	# If yes, then compute `p`-quotients under $H$.
	if LINS_OGL(s, p) mod index = 0 then
		return true;
	fi;

	# All above questions were answered with no.
	# Do not compute `p`-quotients under $H$.
	return false;
end);


#############################################################################
##  LINS_ExponentSum
#############################################################################
##  Description:
##
##  Calculate the exponent sum `n`-size vector of `word` in GF(`p`)
#############################################################################

BindGlobal("LINS_ExponentSum", function(n, p, word)
	local
	rep,    # [(letter, pos-int)]: 	exponent representaton of word, i.e.
			#						a tuple $(a, b)$ represents the subword
			#						$a ^ b$ of `word`
	i,      # pos-int:				loop variable
	res;    # [int]:				exponent sum `n`-size vector of `word`

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
##  LINS_PullBackH
#############################################################################
##  Description:
##
##  Compute the group homomorphism into the symmetric group
##  representing the action of H on H/K by multiplication
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
	s,        # index of m in V, which equals index of K in H
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
		s := p ^ ( Dimension(V) - Dimension(m) );
		if s > n / Index(G, H) then
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
##  LINS_FindTQuotients
#############################################################################
##  Input:
##
##	- gr : 		LINS graph
##  - rH : 		LINS node in gr
##  - primes : 	set containing all primes up to `IndexBound(gr)`
##  - opts : 	LINS options (see documentation)
#############################################################################
##  Usage:
##
##  The main function `LowIndexNormalSubgroupsSearch` calls this function
##  in the main loop.
#############################################################################
##  Description:
##
##  Let the group $G$ be located in the root node of the LINS graph `gr`.
##  Let the group $H$ be located in the node `rH`.
##  Let $n$ be the index bound of the LINS graph `gr`.
##
##  Compute every normal subgroup $K$ of $G$, such that $[G:K] <= n$
##  and $H/K$ is a $p$-group for a prime $p$ contained in `primes`,
##  if `LINS_MustCheckP` says that $p$ needs to be explicitly considered.
#############################################################################

InstallGlobalFunction(LINS_FindPQuotients, function(gr, rH, primes, opts)
	local
	G,      # group: 		located in the root node of LINS graph `gr`.
	H,      # group: 		located in the node `rH`.
	n,		# pos-int: 		index bound of LINS graph `gr`.
	p;      # pos-int:		loop variable, prime in `primes`.

	# Initialize data from input
	G := Grp(Root(gr));
	n := IndexBound(gr);
	H := Grp(rH);

	# Search for p-quotients for every prime small enough.
	for p in primes do
		if p > n / Index(rH) then
			break;
		fi;
		# Check according to some rules whether the p-quotients
		# will be computed by intersections.
		if LINS_MustCheckP(rH, n, p) then
			# Compute all p-quotients under H.
			LINS_FindPModules(gr, rH, p, opts);
		fi;
	od;
end);
