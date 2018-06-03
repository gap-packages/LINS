AddGroup := function(GroupsFound, H, Supers, test)   
  local G, Current, NewGroupsFound, K, Position, S, I, J; 
  
    # Prepare the updated list of found groups
  G := GroupsFound[1].Group;
  Current := 1;
  NewGroupsFound := [];
  
    # Insert every group with smaller index than H to the NewGroupsFound list.
    # If test is enabled then check wether the group H is already contained in GroupsFound list.
  while Current in [1..Length(GroupsFound)] and GroupsFound[Current].Index <= Index(G,H) do
    K := GroupsFound[Current];
    NewGroupsFound[Current] := K;
    if test and K.Index = Index(G,H) then
      if IsSubgroup(K.Group,H) then
        K.Supergroups := Union(K.Supergroups,Supers);
        return GroupsFound;
      fi;
    fi;
    Current := Current + 1;
  od;
  
    # Insert the group H to the NewGroupsFound list and store the Position.
  Position := Current;
  NewGroupsFound[Position] := rec(Group:=H,Index:=Index(G,H),Supergroups:=Supers);
  H := NewGroupsFound[Position];
  
    # Insert every group with bigger index than H to the NewGroupsFound list.
    # Update the information on positions of Supergroups if neccessary
  for Current in [Position..Length(GroupsFound)] do
    NewGroupsFound[Current+1] := GroupsFound[Current];
    S := GroupsFound[Current].Supergroups;
    I := Filtered(S, i -> i < Position);
    J := Filtered(S, i -> i >= Position);
    J := List(J, i -> i+1);
    NewGroupsFound[Current+1].Supergroups := Union(I,J);
  od;
  
    # Search for all possible Supergroups of H.
  for Current in [1..Position-1] do
    K := NewGroupsFound[Current];
    if not (Current in H.Supergroups) then
      if H.Index mod K.Index = 0 then
        if IsSubset(K.Group,H.Group) then
          Add(H.Supergroups,Current);
        fi;     
      fi;
    fi; 
  od;
  
    # Search for all possible Subgroups of H.
  for Current in [Position+1..Length(NewGroupsFound)] do
    K := NewGroupsFound[Current];
    if not (Position in K.Supergroups) then
      if K.Index mod H.Index = 0 then
        if IsSubset(H.Group,K.Group) then
          Add(H.Supergroups,Position);
        fi;     
      fi;
    fi; 
  od;
  
  return NewGroupsFound;
end;
