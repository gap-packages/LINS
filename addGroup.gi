##
## Add the group H to the list GroupsFound.
## Supers is a list of positions of supergroups in the list GroupsFound.
## If test is true, then it is checked, if the group H is not already contained in the list GroupsFound.
## The Group H will be inserted in the list GroupsFound after the last Group with smaller or equal index in G.
## All references to position of supergroups will get updated in the list GroupsFound.
##
InstallGlobalFunction(AddGroup, function(GroupsFound, H, Supers, test)   
  local G, Current, NewGroupsFound, K, Position, S, I, J; 
  
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
      if IsSubgroup(K.Group,H) then
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
        if IsSubgroup(K.Group,H.Group) then
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
        if IsSubgroup(H.Group,K.Group) then
          AddSet(K.Supergroups,Position);
        fi;     
      fi;
    fi; 
  od;
  
  return [NewGroupsFound,Position];
end);
