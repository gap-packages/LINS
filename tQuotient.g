##
## Let the group G be located in the list GroupsFound at position 1.
## Let the group H be located in the list GroupsFound at position Current.
## Calculate every normal subgroup K of G, such that the quotient H/K is 
## isomorphic to some non-abelian group Q, where QQ has stored some information about Q,
## and the index [G:K] is less equal n,
## and add any such group K to the List GroupsFound by calling the AddGroup-function
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
##
TQuotient := function(GroupsFound, n, Current, QQ)
  local G, H, I, Q, m, LL, L, i, K, Iso, IH, PL;
  
  # References to the Groups in the list GroupsFound.
  G := GroupsFound[1].Group;
  H := GroupsFound[Current].Group;
  
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
    return GroupsFound;
  fi;
  
  # Calculate every subgroup of H up to the maximum index in I
  # by calling the Low-Index-Subgroups-Prodecure.
  m := Maximum(I);
  Iso := IsomorphismFpGroup(H);
  IH := Image(Iso);
  LL := LowIndexSubgroupsFpGroup(IH, m);
  
  # Search every subgroup L with an index in G contained in I.
  # Then calculate the core of L and try to add the new Group
  # to the list GroupsFound by calling AddGroup-function
  for L in LL do
    PL := PreImage(Iso, L);
    for i in I do
      if Index(G,PL) = i then
        K := Core(G, PL);
        if Index(G,K) <= n then
          GroupsFound := AddGroup(GroupsFound,K,[1],true);
        fi;
        break;
      fi;
    od;
  od;
  
  # Return the updated list GroupsFound
  return GroupsFound;
end;
