#############################################################################
##  findTQuotients.gi
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
##  LINS_FindTQuotients
#############################################################################
##  Input:
##
##	- gr : 		LINS graph
##  - rH : 		LINS node in gr
##  - QQ : 		list containing information about
##				certain non-abelian groups (see below)
##  - opts : 	LINS options (see documentation)
#############################################################################
##  Description:
##
##  Let the group $G$ be located in the root of the LINS graph `gr`.
##  Let the group $H$ be located in the node `rH`.
##  Calculate every normal subgroup $K$ of $G$,
##  such that the quotient $H/K$ is
##  isomorphic to some non-abelian group $Q$,
##  where `QQ` has stored some information about $Q$,
##  and the index $[G:K]$ is less equal $n$.
##  Add any such group $K$ to the LINS graph `gr`.
##
##
##  The pregenerated list `QQ` will contain the following information
##  in form of tuples of any such group $Q$
##  with group order up to the maximum index boundary `LINS_maxIndex`.
##  Let $Q$ be such a group of interest,
##  then the information about $Q$ will be consisting of the following:
##
##  - 1 : the group order
##  - 2 : an index of some group $S$, that has trivial core in $Q$
##
##  The list $QQ$ is sorted by information $1$.
##  Then any normal subgroup $K$ of $G$,
##  such that the quotient $H/K$ is isomorphic to some $Q$ in the list $QQ$,
##  can be found as the normal core of a subgroup $L$ of $H$,
##  that has an index equal to information $2$.
##  In order to find the subgroup $L$ of $H$,
##  we use `LowIndexSubgroups` to calculate every subgroup of $H$
##  up to some sufficiently large enough index.
#############################################################################

InstallGlobalFunction( LINS_FindTQuotients, function(gr, rH, QQ, opts)
	local
	G,      # group: 		located in the root of LINS graph `gr`.
	H,      # group: 		located in the node `rH`.
	n,		# pos-int: 		index bound
	I,      # [pos-int]: 	every index we need to check
	m,      # pos-int: 		maximum of `I`
	Iso,    # isomorphism: 	from `H` into fp-group
	IH,     # fp-group: 	image under `Iso`, isomorphic to `H`
	LL,     # [group]: 		all subgroups of `IH` with index at most `m`
	L,      # group: 		loop var, subgroup in `LL`
	i,      # pos-int: 		loop var, index in `I`
	PL,     # group: 		preimage of `L` under `Iso`, subgroup of `H`
	K;      # group: 		normal core of `PL` in `G`, subgroup of `H` (with Q-quotient)

	# Initialize data from input
	G := Grp(Root(gr));
	H := Grp(rH);
	n := IndexBound(gr);

	# Calculate the index list `I`.
	I := opts.FilterTQuotients(gr, rH, QQ);

	# If the index list is empty, we have nothing to do.
	if Length(I) = 0 then
		return;
	fi;

	# Calculate every subgroup of `H` up to the maximum index in `I`
	# by calling `LowIndexSubgroups`.
	m := Maximum(I);
	Iso := IsomorphismFpGroup(H);
	IH := Image(Iso);
	LL := LowIndexSubgroupsFpGroup(IH, m);

	# Search every subgroup `L` with an index in `H` contained in `I`.
	# Then calculate the core of `L` and try to add the new subgroup to `gr`.
	for L in LL do
		PL := PreImage(Iso, L);
		for i in I do
			if Index(H, PL) = i then
				# Compute normal core, a subgroup of `H` (with Q-quotient)
				K := Core(G, PL);
				if opts.DoSetParent then
					LINS_SetParent(K, G);
				fi;

				if Index(G, K) <= n then
					LINS_AddGroup(gr, K, [rH], true, opts);
				fi;

				break;
			fi;
		od;
	od;
end);
