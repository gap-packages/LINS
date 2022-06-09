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
##  Usage:
##
##  The main function `LowIndexNormalSubgroupsSearch` calls this function with
##
##						`rH` = `LinsRoot(gr)`,
##						`QQ` = `LINS_TargetsQuotient`.
#############################################################################
##  Description:
##
##  Let the group $G$ be located in the root node of the LINS graph `gr`.
##  Let the group $H$ be located in the node `rH`.
##  Let $n$ be the index bound of the LINS graph `gr`.
##
##  Compute every normal subgroup $K$ of $G$,
##  such that $[G:K] <= n$ and the quotient $H/K$ is
##  isomorphic to some non-abelian group $Q$ contained in `QQ`,
##  that has a non-trivial subgroup with trivial core.
##  Add any such group $K$ to the LINS graph `gr`.
##
##  The list `QQ` must contain the following information
##  in form of tuples for any such group $Q$:
##
##  - 1 : the group order $|Q|$
##  - 2 : an index of some non-trivial subgroup $S < Q$,
##		  that has trivial core in $Q$
##
##  The list $QQ$ is sorted by information $1$.
##
##  Then any normal subgroup $K$ of $G$,
##  such that the quotient $H/K$ is isomorphic to some $Q$ contained in `QQ`,
##  can be found as the normal core in $G$ of a subgroup $L$ of $H$,
##  that has an index equal to information $2$.
##  In order to find the subgroup $L$ of $H$,
##  we use `LowIndexSubgroups` to calculate every subgroup of $H$
##  up to some sufficiently large enough index.
##
##  Note however, that a group $K$ found by this function
##  must not necessarily have a quotient $H/K$
##  that is isomorphic to some $Q$ contained in `QQ`.
##
##  Returns a tuple [doTerminate, nrSubgroups].
##  - doTerminate is true if the search in `gr` can be terminated.
##  - nrSubgroups is the number of newly found normal subgroups.
#############################################################################

InstallGlobalFunction( LINS_FindTQuotients, function(gr, rH, QQ, opts)
	local
	G,      # group: 		located in the root node of LINS graph `gr`.
	H,      # group: 		located in the node `rH`.
	n,		# pos-int: 		index bound of LINS graph `gr`.
	I,      # [pos-int]: 	every index we need to check
	m,      # pos-int: 		maximum of `I`
	Iso,    # isomorphism: 	from `H` into fp-group
	IH,     # fp-group: 	image under `Iso`, isomorphic to `H`
	LL,     # [group]: 		all subgroups of `IH` with index at most `m`
	L,      # group: 		loop var, subgroup in `LL`
	i,      # pos-int: 		loop var, index in `I`
	PL,     # group: 		preimage of `L` under `Iso`, subgroup of `H`
	K,      # group: 		normal core of `PL` in `G`,
			# 				subgroup of `H` (with Q-quotient)
	rK,		# LINS node:	containing group `K`
	isNew,	# boolean:		whether the group `K` is new in `gr`
	nrFound,# pos-int:		number of newly found normal subgroups
	data;	# tuple:		[`rK`, `isNew`]

	# Initialize data from input
	G := Grp(LinsRoot(gr));
	H := Grp(rH);
	n := IndexBound(gr);
	nrFound := 0;

	# Compute the index list `I`.
	I := Set(opts.FilterTQuotients(gr, rH, QQ));

	Info(InfoLINS, 3, LINS_tab3,
		"Search with index list ", LINS_red, I, LINS_reset, ".");

	# If the index list is empty, we have nothing to do.
	if Length(I) = 0 then
		return [false, 0];
	fi;

	# Compute every subgroup of `H` up to the maximum index in `I`
	# by calling `LowIndexSubgroups`.
	m := Maximum(I);
	Iso := IsomorphismFpGroup(H);
	IH := Image(Iso);
	LL := LowIndexSubgroupsFpGroup(IH, m);
	Info(InfoLINS, 3, LINS_tab3,
		LINS_blue, "LowIndexSubgroups ", LINS_reset, "computed ",
		LINS_red, Length(LL), LINS_reset, " subgroups up to index ",
		LINS_red, m, LINS_reset, ".");

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
					data := LINS_AddGroup(gr, K, [rH], true, opts);
					rK := data[1];
					isNew := data[2];
					if isNew then
						nrFound := nrFound + 1;
						Info(InfoLINS, 3, LINS_tab3,
							"Found new normal subgroup ", LINS_red, "K = ", K, LINS_reset,
							" of index ", LINS_red, Index(G, K), LINS_reset, ".");
					fi;
					if isNew and opts.DoTerminate(gr, rH, rK) then
						gr!.TerminatedUnder := rH;
						gr!.TerminatedAt := rK;
						return [true, nrFound];
					fi;
				fi;

				break;
			fi;
		od;
	od;

	return [false, nrFound];
end);
