##
## Returns true if H is a subgroup of G.
## Both H and G must be subgroups of the same finitely presented group.
## We need coset tables of both H and G in the supergroup.
##
InstallGlobalFunction(IsSubgroupFp, function(G, H)
  local word;
  for word in AugmentedCosetTableInWholeGroup(H).primaryGeneratorWords do
    if RewriteWord(AugmentedCosetTableInWholeGroup(G), word) = fail then
      return false;
    fi;
  od;
  return true;
end);

##
## Add the group H to the list GroupsFound.
## Supers is a list of positions of supergroups in the list GroupsFound.
## If test is true, then it is checked, if the group H is not already contained in the list GroupsFound.
## The group H will be inserted in the list GroupsFound after the last group with smaller or equal index in G.
## All references to positions of supergroups will get updated in the list GroupsFound.
## The function returns a tupel with the updated list and the position where H can be found in the new list.
##
InstallGlobalFunction(AddGroup, function(GroupsFound, H, Supers, test)   
  local 
    G,                      # the parent group, which is stored at the first position in GroupsFound
    NewGroupsFound,         # the updated list of groups after insertion of H
    Current,                # Loop variable, position of current group to be inserted
    K,                      # the group (record) at position Current
    Position,               # the position, where H is inserted
    S,                      # supergroups entry of K
    I,                      # set of positions
    J,                      # set of positions
    Subs;                   # subgroups of K
  
  # Prepare the updated list of found groups.
  G := GroupsFound[1].Group;
  Current := 1;
  NewGroupsFound := [];
  
  # Insert every group with smaller index than H to the list NewGroupsFound.
  while Current in [1..Length(GroupsFound)] and GroupsFound[Current].Index <= Index(G,H) do
    K := GroupsFound[Current];
    NewGroupsFound[Current] := K;
    # If test is true, then check if the group H is already contained in the list GroupsFound.
    if test and K.Index = Index(G,H) then
      if IsSubgroupFp(K.Group,H) then
        UniteSet(K.Supergroups,Supers);
        return [GroupsFound,Current];
      fi;
    fi;
    Current := Current + 1;
  od;
  
  # Insert the group H to the list NewGroupsFound and store the Position.
  Position := Current;
  Supers := Set(Concatenation(List(Supers, s-> Concatenation([s],GroupsFound[s].Supergroups))));
  NewGroupsFound[Position] := rec(Group:=H,Index:=Index(G,H),Supergroups:=Supers,TriedPrimes:=[]);
  H := NewGroupsFound[Position];
  
  # Insert every group with bigger index than H to the NewGroupsFound list.
  # Update the information on positions of Supergroups if neccessary.
  for Current in [Position..Length(GroupsFound)] do
    NewGroupsFound[Current+1] := GroupsFound[Current];
    S := GroupsFound[Current].Supergroups;
    I := Filtered(S, i -> i < Position);
    J := Filtered(S, i -> i >= Position);
    J := List(J, i -> i+1);
    NewGroupsFound[Current+1].Supergroups := SSortedList(Union(I,J));
  od;
  
  # Search for all possible Supergroups of H.
  for Current in Reversed([1..(Position-1)]) do
    K := NewGroupsFound[Current];
    if not (Current in H.Supergroups) then
      if H.Index mod K.Index = 0 then
        if IsSubgroupFp(K.Group,H.Group) then
          UniteSet(H.Supergroups,Concatenation([Current],NewGroupsFound[Current].Supergroups));
        fi;     
      fi;
    fi; 
  od;
  
  # Search for all possible Subgroups of H.
  for Current in [(Position+1)..Length(NewGroupsFound)] do
    K := NewGroupsFound[Current];
    if not (Position in K.Supergroups) then
      if K.Index mod H.Index = 0 then
        if IsSubgroupFp(H.Group,K.Group) then
          AddSet(K.Supergroups,Position);
          for Subs in Filtered([Current+1..Length(NewGroupsFound)], i -> Current in NewGroupsFound[i].Supergroups) do
            AddSet(NewGroupsFound[Subs].Supergroups,Position);
          od;
        fi;     
      fi;
    fi; 
  od;
  
  return [NewGroupsFound,Position];
end);
