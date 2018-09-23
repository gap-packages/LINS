##
## Calculate the exponent sum n-size vector of word in Fp
##
InstallGlobalFunction(ExponentSum, function(n,p,word)
  local rep,i,res;
  i := 1;
  res := List([1..n],x->0);
  rep := ExtRepOfObj(word);
  while Length(rep) >= 2*i do
    res[rep[2*i-1]] := rep[2*i];
    i := i + 1;
  od;
  return List(res,x -> x * MultiplicativeNeutralElement(FiniteField(p))); ;
end);


##
## Calculate the GroupHomomorphism into the symmetric group 
## representing the action of H on H/K by multiplication
##
InstallGlobalFunction(PullBackH, function(GenM,p,Gens,O,Mu,Psi) 
  return List([1..Length(Gens)],i->PermList(List([1..Length(O)],j->Position(O,O[j]+(ExponentSum(Length(GenM),p,Gens[i]^Mu))^Psi))));
end);

##
## maximal Generators of the PQuotient.
##
LINS_maxPGenerators := 1000;

##
## Let the group G be located in the list GroupsFound at position 1.
## Let the group H be located in the list GroupsFound at position Current.
## Calculate every normal subgroup K of G, such that H/K is a p-Group
## and the index in G is less equal n.
##
## We construct a module over the groupring (F_p G) and compute maximal submodules of this module.
## These submodules can be translated into the subgroups of H we are searching for, namely elementary abelian p-Quotients.
## Then we call the method on the found subgroups so we compute all p-Quotients and not only the elementary abelian ones.
##
InstallGlobalFunction(FindPModules, function(GroupsFound, n, Current, p)   
  local G, H, Iso, IH, P, M, Mu, GenM, word, gen, gens, GM, MM, m, i, j, x, y, V, r, PsiHom, Q, O, GenIH, PhiHom, K, NewGroup; 
  
  # Check if p-Quotients have been computed already from this group
  if p in GroupsFound[Current].TriedPrimes then
    return GroupsFound;
  fi;
  AddSet(GroupsFound[Current].TriedPrimes,p);
  
  # References to the Groups in the list GroupsFound.
  G := GroupsFound[1].Group;
  H := GroupsFound[Current].Group;

  # Isomorphism onto the fp-group of H
  Iso := IsomorphismFpGroup(H);
  IH := Image(Iso);
  
  # Create the Isomorphism to the group structure of the p-Module M
  P := PQuotient(IH, p, 1, LINS_maxPGenerators);
  Mu := EpimorphismQuotientSystem(P);
  M := Image(Mu);
  GenM := GeneratorsOfGroup(M);

  # If M is trivial we skip this prime
  if IsEmpty(GenM) then
    return GroupsFound;
  fi;
  
  # Define the group action of G on the p-Module M
  # For every generator in G we store the action on M in form of a Matrix
  gens := [];
  for x in GeneratorsOfGroup(G) do
    gen := [];
    for y in GenM do
      y := PreImagesRepresentative(Iso,PreImagesRepresentative(Mu,y));
      word := Image(Mu, Image(Iso, x*y*x^(-1) ));
      Add(gen, ExponentSum(Length(GenM),p,word));
    od;
    Add(gens,gen);
  od;
  
  # Calculate the maximal submodules of M
  GM := GModuleByMats(gens, FiniteField(p));
  MM := MTX.BasesMaximalSubmodules(GM);
  V := FiniteField(p)^(Length(GenM));
  
  # Translate every submodule of M into a normal subgroup of H with elementary abelian p-Quotient
  for m in MM do
    
    # Check wether the index will be greater than n
    m := Subspace(V,m);
    r := p^( Dimension(V) - Dimension(m) );
    if r > n / Index(G, H) then
      continue;
    fi;
    
    # Calculate the natural homomorphism from V to V/m
    PsiHom := NaturalHomomorphismBySubspace(V,m);
    Q := Image(PsiHom);
    O := Elements(Q);
    GenIH := GeneratorsOfGroup(IH);
    
    # Calculate the subgroup K with H/K being an elementary abelian p-Group
    PhiHom :=  GroupHomomorphismByImagesNC(H,SymmetricGroup(Length(O)),PullBackH(GenM,p,List(GeneratorsOfGroup(H),x->Image(Iso,x)),O,Mu,PsiHom));
    K := Kernel(PhiHom);
    
    # Add the subgroup K by calling the addGroup-function
    if Index(G, K) <= n then
      NewGroup := AddGroup(GroupsFound,K,SSortedList([1,Current]),true);
      GroupsFound := NewGroup[1];
      # If the index is sufficient small, compute p-Quotients from the subgroup K
      if p <= n / Index(G, K) then
        GroupsFound := FindPModules(GroupsFound, n, NewGroup[2], p);
      fi;
    fi;
  od;  
  
  return GroupsFound;
end);             
