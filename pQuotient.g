  #Calculate the GroupHom
helper := function(GenM,p,Gens,O,Mu,Psi) 
  return List([1..Length(Gens)],i->PermList(List([1..Length(O)],j->Position(O,O[j]+(MtoVS(GenM,p,Gens[i]^Mu))^Psi))));
end;

  #Calculate the exponent vector of word in Fp
MtoVS := function(GenM,p,word) 
  return List([1..Length(GenM)],i -> ExponentSumWord(word![1],GenM[i]![1]) * MultiplicativeNeutralElement(FiniteField(p))); 
end;


PPQuotient := function(GroupsFound, n, Current)
  local G, H, p, Iso, IH, F, GenF, ComRel, Rel, M, Mu, GenM, word, gen, gens, Mcomp, GM, MM, m, i, j, x, y, z, SGen, S, countvector, PsiHom, Q, O, GenIH, PhiHom, V;
  G := GroupsFound[1].Group;
  H := GroupsFound[Current].Group;
  p := 2;
  Iso := IsomorphismFpGroup(H);
  IH := Image(Iso);
  F := FreeGroupOfFpGroup(IH);
  GenF := GeneratorsOfGroup(F);
  ComRel := [];
    # Calculate the commutator relations for the p-Module M
  for i in [1..Length(GenF)] do
    for j in [(i + 1)..Length(GenF)] do
      Add(ComRel, Comm(GenF[i], GenF[j]) );
    od;
  od;

  while p <= n / Index(G, H) do 
    
      # Create the Isomorphism to the group structure of the p-Module M
    Rel := [];
    for i in [1..Length(GenF)] do
      Add(Rel, GenF[i]^p);
    od;
    M := F / Union(RelatorsOfFpGroup(IH), Rel, ComRel);
    Mu := IsomorphismSimplifiedFpGroup(M);
    Mu := CompositionMapping(Mu,GroupHomomorphismByImagesNC(IH, M));
    M := Image(Mu);

      # Define the group action of G on the p-Module M
      # For every generator in G we store the action on M in form of a Matrix
    gens := [];
    GenM := GeneratorsOfGroup(M);
      # If M is trivial we skip this prime
    if IsEmpty(GenM) then
      p := NextPrimeInt(p);
      continue;
    fi;
    for x in GeneratorsOfGroup(G) do
      gen := [];
      for y in GenM do
        y := PreImagesRepresentative(Iso,PreImagesRepresentative(Mu,y));
        word := Image(Mu, Image(Iso, x*y*x^(-1) ));
        Add(gen, MtoVS(GenM,p,word));
      od;
      Add(gens,gen);
    od;
    
      #Search the maximal submodules of GM
    GM := GModuleByMats(gens, FiniteField(p));
    MM := MTX.BasesMaximalSubmodules(GM);
    V := FiniteField(p)^(Length(GenM));
    for m in MM do
      m := Subspace(V,m);
      r := Int(Floor(Log(Float(QuoInt(n,Index(G,H))))/Log(Float(p))+0.1));
      if Dimension(V)-Dimension(m) >= r or Dimension(V)-Dimension(m) = 0 then
        continue;
      fi;
      PsiHom := NaturalHomomorphismBySubspace(V,m);
      Q := Image(PsiHom);
      O := Elements(Q);
      GenIH := GeneratorsOfGroup(IH);
      PhiHom :=  GroupHomomorphismByImagesNC(H,SymmetricGroup(Length(O)),helper(GenM,p,List(GeneratorsOfGroup(H),x->Image(Iso,x)),O,Mu,PsiHom));
      S := Kernel(PhiHom);
      if Index(G, S) <= n then
        GroupsFound := AddGroup(GroupsFound,S,[1,Current],true);
      fi;
    od;
    p := NextPrimeInt(p);
  od; 
  return GroupsFound;
end;
