InstallGlobalFunction(FindPModules, function(GroupsFound, n, Current, p)   
    local maxPGenerators, G, H, Iso, IH, P, M, Mu, GenM, word, gen, gens, GM, MM, m, i, j, x, y, V, r, PsiHom, Q, O, GenIH, PhiHom, K; 
  maxPGenerators := 1000;
  
  # References to the Groups in the list GroupsFound.
  G := GroupsFound[1].Group;
  H := GroupsFound[Current].Group;

  # Isomorphism onto the fp-group of H
  Iso := IsomorphismFpGroup(H);
  IH := Image(Iso);
  
  # Create the Isomorphism to the group structure of the p-Module M
  #Mu := EpimorphismPGroup(IH,p,1);
  P := PQuotient(IH, p, 1, maxPGenerators);
  Mu := EpimorphismQuotientSystem(P);
  M := Image(Mu);
  GenM := GeneratorsOfGroup(M);

  # If M is trivial we skip this prime
  if IsEmpty(GenM) then
    p := NextPrimeInt(p);
    continue;
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
      if p <= n / Index(G, K) then
        GroupsFound := FindPModules(GroupsFound, n, NewGroup[2], p);
      fi;
    fi;
  od;  
  
  return GroupsFound;
end);             
