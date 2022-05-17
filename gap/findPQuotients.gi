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
