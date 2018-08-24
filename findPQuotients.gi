##
## Calculate the exponent sum n-size vector of word in Fp
##
ExponentSum := function(n,p,word)
  local rep,i,res;
  i := 1;
  res := List([1..n],x->0);
  rep := ExtRepOfObj(word);
  while Length(rep) >= 2*i do
    res[rep[2*i-1]] := rep[2*i];
    i := i + 1;
  od;
  return List(res,x -> x * MultiplicativeNeutralElement(FiniteField(p))); ;
end;


##
## Calculate the GroupHomomorphism into the symmetric group 
## representing the action of H on H/K by left multiplication
##
PullBackH := function(GenM,p,Gens,O,Mu,Psi) 
  return List([1..Length(Gens)],i->PermList(List([1..Length(O)],j->Position(O,O[j]+(ExponentSum(Length(GenM),p,Gens[i]^Mu))^Psi))));
end;

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
    
    if( MustCheckP(p, Index(G, H), MinSubgroupSizes(GroupsFound, Current)) ) 
    then
      GroupsFound := FindPModules(GroupsFound, n, Current, p);
    fi;
    
    # Check the next prime
    p := NextPrimeInt(p);
  od; 
  
  # Return the updated list GroupsFound
  return GroupsFound;
end);
