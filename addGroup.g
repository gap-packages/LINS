# G is the group in which we search for normal subgroups.
# list is the collection of all distinct normal subgroups in G we have found so far.
# newlist is the collection of new normal subgroups we may want to add to the list.
#
# the method AddGroups checks for every entry in newlist 
# if we have found a normal group which is not contained in list
# and add such an entry to the list.
AddGroups := function(G, list, newlist)
  #local H, K, isEqual, add, word; 
  local H, K, add; 
  
  for H in newlist do
    #Should be the group H added
    add := true;
    for K in list do
      # First check if the index is equal
      if Index(G, H) = Index(G, K) then
        # Are the subgroups K and H identical?
        if IsSubgroup(K,H) then
          add := false;
          break;
        fi;
      fi;
      
      #isEqual := true;
      #for word in AugmentedCosetTableInWholeGroup(K).primaryGeneratorWords do
      #  if RewriteWord(AugmentedCosetTableInWholeGroup(H), word) = fail then
      #    isEqual := false;
      #    break;
      #  fi;
      #od;
      #if isEqual = true then
      #  add := false;
      #  break;
      #fi;
      
    od;
    # The group H is a new normal group, so we want to add it to the list
    if add = true then   
      Add(list,H);
    fi;
  od;
end;
