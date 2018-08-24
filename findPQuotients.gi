##
## Let the group G be located in the list GroupsFound at position 1.
## Let the group H be located in the list GroupsFound at position Current.
## Calculate every normal subgroup K of G, such that H/K is an elementary abelian p-Group
## and the index in G is less equal n.
##
InstallGlobalFunction(FindPQuotients, function(GroupsFound, n, Current)
  local G, H, p;
  
  # References to the Groups in the list GroupsFound.
  G := GroupsFound[1].Group;
  H := GroupsFound[Current].Group;

  # Search for p-Quotients for every prime small enough.
  p := 2;
  while p <= n / Index(G, H) do 
    
    if( MustCheckP(n, p, Index(G, H), MinSubgroupSizes(GroupsFound, Current)) ) 
    then
      GroupsFound := FindPModules(GroupsFound, n, Current, p);
    fi;
    
    # Check the next prime
    p := NextPrimeInt(p);
  od; 
  
  # Return the updated list GroupsFound
  return GroupsFound;
end);
