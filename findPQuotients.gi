##
## Calculate the exponent n-size vector of word
##
ExponentSum := function(n,word)
  local rep,i,res;
  i := 1;
  res := List([1..n],x->0);
  rep := ExtRepOfObj(word);
  while Length(rep) >= 2*i do
    res[rep[2*i-1]] := rep[2*i];
    i := i + 1;
  od;
  return res;
end;

##
## Calculate the exponent vector of word in Fp
##
MtoVS := function(n,p,word) 
  return List(ExponentSum(n,word),x -> x * MultiplicativeNeutralElement(FiniteField(p))); 
end;

##
## Calculate the GroupHomomorphism into the symmetric group 
## representing the action of H on H/K by left multiplication
##
PullBackH := function(GenM,p,Gens,O,Mu,Psi) 
  return List([1..Length(Gens)],i->PermList(List([1..Length(O)],j->Position(O,O[j]+(MtoVS(Length(GenM),p,Gens[i]^Mu))^Psi))));
end;

##
## Let the group G be located in the list GroupsFound at position 1.
## Let the group H be located in the list GroupsFound at position Current.
## Calculate every normal subgroup K of G, such that H/K is an elementary abelian p-Group
## and the index in G is less equal n.
##
InstallGlobalFunction(FindPQuotients, function(GroupsFound, n, Current)
  local G, H, p, Iso, IH, M, Mu, GenM, word, gen, gens, GM, MM, m, i, j, x, y, V, r, PsiHom, Q, O, GenIH, PhiHom, K;
  
  # References to the Groups in the list GroupsFound.
  G := GroupsFound[1].Group;
  H := GroupsFound[Current].Group;

  # Isomorphism onto the fp-group of H
  Iso := IsomorphismFpGroup(H);
  IH := Image(Iso);
  
  # Search for p-Quotients for every prime small enough.
  p := 2;
  while p <= n / Index(G, H) do 
    
    # Create the Isomorphism to the group structure of the p-Module M
    Mu := EpimorphismPGroup(IH,p,1);
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
        Add(gen, MtoVS(Length(GenM),p,word));
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
      r := Int(Floor(Log(Float(QuoInt(n,Index(G,H))))/Log(Float(p))+0.1));
      if Dimension(V)-Dimension(m) >= r or Dimension(V)-Dimension(m) = 0 then
        #continue;
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
        GroupsFound := AddGroup(GroupsFound,K,[1,Current],true);
      fi;
    od;
    
    # Check the next prime
    p := NextPrimeInt(p);
  od; 
  
  # Return the updated list GroupsFound
  return GroupsFound;
end);
