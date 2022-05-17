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
## Let the group G be located in the list GroupsFound at position 1.
## Let the group H be located in the list GroupsFound at position Current.
## Calculate every normal subgroup K of G, such that the quotient H/K is
## isomorphic to some non-abelian group Q, where QQ has stored some information about Q,
## and the index [G:K] is less equal n,
## and add any such group K to the List GroupsFound by calling the LINS_AddGroup-function.
##
##
## The pregenerated list QQ will contain the following information in form of tupels of any such group Q
## with group order up to the maximum index boundary max_index.
## Let Q be such a group of interest, then the information about Q will be consisting of the following:
## 1 : the group order
## 2 : an index of some group S, that has trivial core in Q
## The list QQ is sorted by information 1.
## Then any normal subgroup K of G, such that the quotient H/K is isomorphic to some Q in the list QQ
## can be found as the normal core of a subgroup L of H, that has an index equal to information 2.
## In order to find the subgroup L of H, the Low-Index-Subgroups-Procedure will calculate every subgroup of H
## up to some sufficient large enough index.
#############################################################################

InstallGlobalFunction( LINS_FindTQuotients, function(gr, rH, QQ, opts)
  local
    G,      # the parent group, which is stored at the first position in GroupsFound
    n,
    H,      # the group (record) at position Current
    I,      # index list
    Q,      # loop variable, entry of QQ
    m,      # maximum of I
    Iso,    # isomorphism from H into fp-group
    IH,     # fp-group, image of Iso
    LL,     # list of all subgroups of IH with index at most m
    L,      # loop variable, subgroup in LL
    i,      # loop variable, index in I
    PL,     # preimage of L in Iso
    K;      # normal core of PL, subgroup of H with T-quotient

  # References to the Groups in the list GroupsFound.
  G := Grp(Root(gr));
  n := IndexBound(gr);
  H := Grp(rH);

  # Calculate the index list.
  I := [];
  for Q in QQ do
    if Q[1] > n / Index(G,H) then
      break;
    fi;
    Add(I,Q[2]);
  od;

  # If the index list is empty, return the list GroupsFound.
  if Length(I) = 0 then
    return;
  fi;

  # Calculate every subgroup of H up to the maximum index in I
  # by calling the Low-Index-Subgroups-Prodecure.
  m := Maximum(I);
  Iso := IsomorphismFpGroup(H);
  IH := Image(Iso);
  LL := LowIndexSubgroupsFpGroup(IH, m);

  # Search every subgroup L with an index in G contained in I.
  # Then calculate the core of L and try to add the new Group
  # to the list GroupsFound by calling LINS_AddGroup-function
  for L in LL do
    PL := PreImage(Iso, L);
    for i in I do
      if Index(H,PL) = i then
        K := Core(G, PL);
        if opts.DoSetParent then
          LINS_SetParent(K, G);
        fi;
        if Index(G,K) <= n then
          LINS_AddGroup(gr, K, [rH], true, opts);
        fi;
        break;
      fi;
    od;
  od;
end);
