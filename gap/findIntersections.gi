#############################################################################
##  findIntersections.gi
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
##  LINS_FindIntersections
#############################################################################
##  Input:
##
##  - gr :      LINS graph
##  - rH :      LINS node in gr
##  - opts :    LINS options (see documentation)
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
##  Compute all pairwise intersections $U$ of the group $H$
##  with all preceding groups in `gr`, where $[G : U] <= n$.
##
##  Returns a tuple [doTerminate, nrSubgroups].
##  - doTerminate is true if the search in `gr` can be terminated.
##  - nrSubgroups is the number of newly found normal subgroups.#############################################################################

InstallGlobalFunction( LINS_FindIntersections, function(gr, rH, opts)
    local
    rG,             # LINS node:    root node of LINS graph 'gr'.
    G,              # group:        located in the root node `rG`.
    H,              # group:        located in the node `rH`.
    n,              # pos-int:      index bound of LINS graph `gr`.
    allSupergroups, # [LINS node]:  supergroups of `rH`
    allSubgroups,   # [LINS node]:  subgroups of `rH`
    level,          # LINS level:   loop var
    rK,             # LINS node:    loop var, preceding group in `gr`
    K,              # group:        located in the node `rK`
    xgroups,        # [LINS node]:  super/sub-groups of `rK`
    supers,         # [LINS node]:  shared supergroups of `rH` and `rK`
    subs,           # [LINS node]:  shared subgroups of `rH` and `rK`
    rM,             # LINS node:    smallest supergroup of `H` and `K`, being $HK$
    index,          # pos-int:      index of the intersection of `H` and `K`
    U,              # group:        intersection of `H` and `K`
    rU,             # LINS node:    containing group `U`
    nrFound,        # pos-int:      number of newly found normal subgroups
    data;           # tuple:        [`rU`, `isNew`]

    # If the current group is `G`, then continue.
    rG := LinsRoot(gr);
    if rG = rH then
        return false;
    fi;

    # Initialize data
    G := Grp(rG);
    H := Grp(rH);
    n := IndexBound(gr);
    allSupergroups := LinsNodeSupergroups(rH);
    allSubgroups := LinsNodeSubgroups(rH);
    nrFound := 0;

    # Main iteration over all preceding groups in `gr`
    for level in gr!.Levels{[1 .. PositionProperty(gr!.Levels, level -> level.Index = Index(rH))]} do
        for rK in level.Nodes do
            if rK = rH then
                break;
            fi;
            if LinsNodeIsCut(rK) then
                continue;
            fi;
            # If `K` is a supergroup of `H`, then continue.
            if rK in allSupergroups then
                continue;
            fi;
            K := Grp(rK);

            # Find the smallest supergroup of `H` and `K`. (which is $HK$)
            xgroups := LinsNodeSupergroups(rK);
            supers := Filtered(allSupergroups, s -> s in xgroups);
            rM := supers[PositionMaximum(List(supers, Index))];
            index := rK!.Index * rH!.Index / rM!.Index;

            # Check if we need to compute the intersection
            if index > n then
                continue;
            fi;

            # Check if the intersection has been already computed
            xgroups := LinsNodeSubgroups(rK);
            subs := Filtered(allSubgroups, s -> s in xgroups);
            if opts.DoIntersection(gr, rH, rK, index) and not (index in List(subs, Index)) then
                Info(InfoLINS, 3, LINS_tab3,
                    "Group ", LINS_red, "K = ", K, LINS_reset,
                    ", index ", LINS_red, Index(G, K), LINS_reset, ".");

                # Add the intersection to LINS graph `gr`
                nrFound := nrFound + 1;
                U := Intersection(K, H);
                if opts.DoSetParent then
                    LINS_SetParent(U, G);
                fi;

                data := LINS_AddGroup(gr, U, [rK, rH], false, opts);
                rU := data[1];

                Info(InfoLINS, 3, LINS_tab3,
                    "Found new normal subgroup ", LINS_red, "U = H ∩ K = ", U, LINS_reset,
                    " of index ", LINS_red, Index(G, U), LINS_reset, ".");

                if opts.DoTerminate(gr, rH, rU) then
                    gr!.TerminatedUnder := rH;
                    gr!.TerminatedAt := rU;
                    return [true, nrFound];
                fi;
                Add(allSubgroups, rU);
            fi;
        od;
    od;

    return [false, nrFound];
end);
