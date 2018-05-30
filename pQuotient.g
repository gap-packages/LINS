PPQuotient := function(G, n, H)
  local p, Iso, IH, F, GenF, ComRel, Rel, M, Mu, GenM, word, gen, gens, Mcomp, GM, MM, m, list, i, j, x, y, z, SGen, S, countvector, Psi, Q, O, GenIH, Hom;
  list := [];
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
    Mu := CompositionMapping(Mu,GroupHomomorphismByImages(IH, M));
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
        # count how often every generator of M is contained in the word.
        countvector := List([1..Length(GenM)],i -> ExponentSumWord(word![1],GenM[i]![1]));
        Add(gen, List(countvector, z -> MultiplicativeNeutralElement(FiniteField(p)) * z));
      od;
      Add(gens,gen);
    od;
    
    #Search the maximal submodules of GM
    GM := GModuleByMats(gens, FiniteField(p));
    MM := MTX.BasesMaximalSubmodules(GM);
    for m in MM do
      SGen := [];
      # convert the vector basis into group elements of M
      m := List(m, x -> List(x, Int));
      for i in [1..Length(m)] do
        x := MultiplicativeNeutralElement(M);
        for j in [1..Length(m[i])] do
          x := GenM[j]^m[i][j] * x;
        od;
        Add(SGen,x);
      od; 
      # get the subgroup with a p-Quotient in H
      S := Subgroup(M,SGen);
      Psi := NaturalHomomorphismByNormalSubgroup(M,S);
      Q := Image(Psi);
      O := Elements(Q);
      GenIH := GeneratorsOfGroup(IH);
      Hom :=  GroupHomomorphismByImages(IH,SymmetricGroup(Length(O)),helper(GenIH,O,Mu,Psi));
      S := Kernel(Hom);
      S := PreImage(Iso,S);
      if Index(G, S) <= n then
        Add(list,S);
      fi;
    od;
    p := NextPrimeInt(p);
  od; 
  return list;
end;

helper := function(GenIH,O,Mu,Psi) 
  return List([1..Length(GenIH)],i->PermList(List([1..Length(O)],j->Position(O,O[j]*(GenIH[i]^Mu)^Psi))));
end;
