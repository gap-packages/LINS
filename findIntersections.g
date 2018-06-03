FindIntersections := function(GroupsFound, n, Current)
  local H,K,M,F,Other,index;
  if Current = 1 then
    return GroupsFound;
  fi;
  H := GroupsFound[Current];
  for Other in [2..Current-1] do
    if Other in GroupsFound[Current].Supergroups then
      continue;
    fi;
    K := GroupsFound[Other];
    M := GroupsFound[Maximum(Intersection(H.Supergroups,K.Supergroups))];
    index := K.Index * H.Index / M.Index;
    if index >= n then
      continue;
    fi;
    F := Filtered([Current..Length(GroupsFound)], i -> GroupsFound[i].Index = index);
    if ForAny(F, i -> IsSubset(GroupsFound[i].Supergroups,[Current,Other])) then
      continue;
    fi;
    GroupsFound := AddGroup(GroupsFound, Intersection(H.Group,K.Group), [Current,Other], true);
  od;
  return GroupsFound;
end;
