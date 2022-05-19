# Append data to the LINS graph
BindGlobal( "LINS_Index_InitGraph_Wrapper",
function(n, l)
	return function(gr)
		gr!.Index := n;
		gr!.NrFound := 0;
		gr!.NrToFind := l;
		gr!.Output := [];
	end;
end);

# Should subgroups under `rH` be computed?
BindGlobal( "LINS_Index_DoCut",
function(gr, rH)
	if RemInt(gr!.Index, rH!.Index) <> 0 then
		return true;
	fi;
	return false;
end);

# Should the search be terminated?
# We are currently computing the subgroups under `rH`.
# We have computed the normal subgroup `rK`.
# This function may write data to `gr!.Output`.
BindGlobal( "LINS_Index_DoTerminate",
function(gr, rH, rK)
	if rK!.Index = gr!.Index then
		gr!.NrFound := gr!.NrFound + 1;
		Add(gr!.Output, rK);
		if gr!.NrFound = gr!.NrToFind then
			return true;
		fi;
	fi;
	return false;
end);

# Compute the index list from the targets
BindGlobal( "LINS_Index_FilterTQuotients",
function(gr, rH, QQ)
local n, I, Q;
	n := IndexBound(gr);
	I := [];
	for Q in QQ do
		if Q[1] > n / rH!.Index then
			break;
		fi;
		if RemInt(gr!.Index, Q[1]) = 0 then
			Add(I, Q[2]);
		fi;
	od;
	return I;
end);

# Whether to compute the intersection of the groups `rH` and `rK`
# with the given index.
BindGlobal( "LINS_Index_DoIntersection",
function(gr, rH, rK, index)
	if RemInt(gr!.Index, index) = 0 then
		return true;
	fi;
	return false;
end);

# Whether to compute `p`-quotients under `rH` for the prime `p`
BindGlobal( "LINS_Index_DoPQuotient",
function(gr, rH, p)
	if RemInt(gr!.Index, rH!.Index * p) = 0 then
		return true;
	fi;
	return false;
end);

# Whether to compute the elem. abelian `p`-quotient of given index
# under `rH` for the prime `p`
BindGlobal( "LINS_Index_DoPModule",
function(gr, rH, p, index)
	if RemInt(gr!.Index, index) = 0 then
		return true;
	fi;
	return false;
end);

# See documentation
InstallGlobalFunction( LowIndexNormalSubgroupsSearchForIndex, function(G, n, l)
	local opts, initGraph;

	initGraph := LINS_Index_InitGraph_Wrapper(n, l);

	opts := rec(
		InitGraph := initGraph,
		DoCut := LINS_Index_DoCut,
		DoTerminate := LINS_Index_DoTerminate,
		FilterTQuotients := LINS_Index_FilterTQuotients,
		DoIntersection := LINS_Index_DoIntersection,
		DoPQuotient := LINS_Index_DoPQuotient,
		DoPModule := LINS_Index_DoPModule
	);

	return LowIndexNormalSubgroupsSearch(G, n, opts);
end);