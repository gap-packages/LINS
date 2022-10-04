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


BindGlobal("Terminate", MakeImmutable("Terminate"));

# Terminate, if we found sufficient enough groups
# true, if K is a new group
# false, if K was already found beforehand
BindGlobal("LINS_AddGroup_Caller",
function(gr, rH, K, opts, infoText)
    local
    G,      # group:        located in the root node of the LINS graph `gr`.
    n,      # pos-int:      index bound of LINS graph `gr`.
    data,   # tuple:        [`rK`, `isNew`]
    rK,     # LINS node:    containing group `K`
    isNew;  # boolean:      whether the group `K` is new in `gr`

    G := Grp(LinsRoot(gr));
    n := IndexBound(gr);

    if opts.DoSetParent then
        LINS_SetParent(K, G);
    fi;

    if Index(G, K) <= n then
        data := LINS_AddGroup(gr, K, [rH], true, opts);
        rK := data[1];
        isNew := data[2];

        if isNew then
            Info(InfoLINS, 3, LINS_tab3, infoText,
                "Found new normal subgroup ", LINS_red, "K = ", K, LINS_reset,
                " of index ", LINS_red, Index(G, K), LINS_reset, ".");

            if opts.DoTerminate(gr, rH, rK) then
                gr!.TerminatedUnder := rH;
                gr!.TerminatedAt := rK;
                return Terminate;
            else
                return true;
            fi;
        fi;
    fi;

    return false;
end);

#############################################################################
##  LINS_FindTQuotients
#############################################################################
##  Input:
##
##  - gr :        LINS graph
##  - opts :      LINS options (see documentation)
#############################################################################
##  Usage:
##
##  The main function `LowIndexNormalSubgroupsSearch` calls this function.
##  The value of the local variable `targets` depends
##  on the value of `opts.UseLIS`, which is `false` by default
##
##  If `UseLIS` = `false` => `targets` = `LINS_TargetsQuotient`.
##  If `UseLIS` = `true`  => `targets` = `LINS_TargetsQuotientUseLIS`.
#############################################################################
##  Description:
##
##  Let the group $G$ be located in the root node of the LINS graph `gr`.
##  Let $n$ be the index bound of the LINS graph `gr`.
##
##  Compute every normal subgroup $K$ of $G$,
##  such that $[G:K] <= n$ and the quotient $G/K$ is
##  isomorphic to some non-abelian group $Q$ contained in `targets`.
##  Add any such group $K$ to the LINS graph `gr`.
##
##  We now make a case distinction on the value of `opts.UseLIS`.
##
##  -------------------------------------------------------------------------
##  Case `UseLIS` = `false` (Default):
##  -------------------------------------------------------------------------
##  The list `targets` must contain the following information
##  in form of tuples for any such group $Q$:
##
##  - 1 : the group order $|Q|$
##  - 2 : the group $Q$
##
##  The list `targets` is sorted by information $1$.
##
##  Note, that a group $K$ found by this function
##  must necessarily have a quotient $G/K$
##  that is isomorphic to some $Q$ contained in `targets`.
##
##  -------------------------------------------------------------------------
##  Case `UseLIS` = `true`:
##  -------------------------------------------------------------------------
##  The list `targets` must contain the following information
##  in form of tuples for any such group $Q$:
##
##  - 1 : the group order $|Q|$
##  - 2 : an index of some non-trivial subgroup $S < Q$,
##        that has trivial core in $Q$
##
##  The list $targets$ is sorted by information $1$.
##
##  Then any normal subgroup $K$ of $G$,
##  such that the quotient $H/K$ is isomorphic to some $Q$ contained in `targets`,
##  can be found as the normal core in $G$ of a subgroup $L$ of $H$,
##  that has an index equal to information $2$.
##  In order to find the subgroup $L$ of $H$,
##  we use `LowIndexSubgroups` to calculate every subgroup of $H$
##  up to some sufficiently large enough index.
##
##  Note however, that a group $K$ found by this function
##  must not necessarily have a quotient $G/K$
##  that is isomorphic to some $Q$ contained in `targets`.
##  -------------------------------------------------------------------------
##
##  Returns a tuple [doTerminate, nrSubgroups].
##  - doTerminate is true if the search in `gr` can be terminated.
##  - nrSubgroups is the number of newly found normal subgroups.
#############################################################################

InstallGlobalFunction( LINS_FindTQuotients, function(gr, opts)
    local
    rG,                 # LINS node:    root node of LINS graph `gr`.
    G,                  # group:        located in the root node `rG`.
    iso,                # iso:          isomorphism from original group `H` to fp-group `G`
    H,                  # group:        source of `iso`.
    n,                  # pos-int:      index bound of LINS graph `gr`.
    targets,            # list:         list of targets
    filteredTargets,    # list:         filtered list of targets
    I,                  # [pos-int]:    every index we need to check
    m,                  # pos-int:      maximum of `I`
    LL,                 # [group]:      all subgroups of `IH` with index at most `m`
    L,                  # group:        loop var, subgroup in `LL`
    QQ,                 # [group]:      list of quotient isomorphism types
    Q,                  # group:        loop var, quotient in `I`
    homs,               # [hom]:        list of homomorphisms into `Q`
    hom,                # hom:          loop var, homomorphism in `L` from `H` into `Q`
    K,                  # group:        normal subgroup of `G` (with Q-quotient)
    data,               # state:        bool or Terminate
    nrFound;            # pos-int:      number of newly found normal subgroups

    # Initialize data from input.
    rG := LinsRoot(gr);
    G := Grp(rG);
    if IsBound(gr!.Iso) then
        iso := gr!.Iso;
    else
        iso := IdentityMapping(G);
    fi;
    H := Source(iso);
    n := IndexBound(gr);
    nrFound := 0;

    # Filter the targets.
    if opts.UseLIS then
        targets := LINS_TargetsQuotient_UseLIS;
    else
        targets := LINS_TargetsQuotient;
    fi;

    filteredTargets := Set(opts.FilterTQuotients(gr, targets));

    Info(InfoLINS, 3, LINS_tab3,
        "Search with index list ", LINS_red, I, LINS_reset, ".");

    # If the target list is empty, we have nothing to do.
    if Length(filteredTargets) = 0 then
        return [false, 0];
    fi;

    # Compute every subgroup of `G` with quotient `Q` in `filteredTargets`.
    if opts.UseLIS then
        I := List(filteredTargets, entry -> entry[2]);
        m := Maximum(I);
        LL := LowIndexSubgroupsFpGroup(G, m);
        for L in LL do
            if Position(I, Index(G, L)) <> fail then
                K := Core(G, L);
                data := LINS_AddGroup_Caller(gr, rG, K, opts, "");
                if data = true then
                    nrFound := nrFound + 1;
                elif data = Terminate then
                    return [true, nrFound + 1];
                fi;
            fi;
        od;
    else
        QQ := List(filteredTargets, entry -> entry[2]);
        for Q in QQ do
            homs := GQuotients(H, Q);
            for hom in homs do
                K := Image(iso, Kernel(hom));
                data := LINS_AddGroup_Caller(gr, rG, K, opts, "");
                if data = true then
                    nrFound := nrFound + 1;
                elif data = Terminate then
                    return [true, nrFound + 1];
                fi;
            od;
        od;
    fi;

    return [false, nrFound];
end);
