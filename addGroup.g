AddGroups := function(G, NormalSubgroups, NewNormalSubgroups)
  local H, K, isEqual, add, word; 
  for H in NewNormalSubgroups do
    #Should be the group H added
    add := true;
    for K in NormalSubgroups do
      if Index(G, H) <> Index(G, K) then
        continue;
      fi;
      #Is the group H equal to K
      isEqual := true;
      for word in AugmentedCosetTableInWholeGroup(K).primaryGeneratorWords do
        if RewriteWord(AugmentedCosetTableInWholeGroup(H), word) = fail then
          isEqual := false;
          break;
        fi;
      od;
      if isEqual = true then
        add := false;
        break;
      fi;
    od;
    if add = true then   
      Add(NormalSubgroups,H);
    fi;
  od;
end;