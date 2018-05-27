PPQuotient := function(G, n, H)
  local p, Iso, IH, F, GenF, ComRel, Rel, Mu, GenM, word, gen, gens, Mcomp, M, GM, MM, m, list, i, j, x, y, z, subgroup, countvector;
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
      subgroup := [];
      # convert the vector basis into group elements of M
      m := List(m, x -> List(x, Int));
      for i in [1..Length(m)] do
        x := MultiplicativeNeutralElement(M);
        for j in [1..Length(m[i])] do
          x := GenM[j]^m[i][j] * x;
        od;
        Add(subgroup,x);
      od; 
      # get the subgroup with a p-Quotient in H
      subgroup := PreImage(Iso,PreImage(Mu,Subgroup(M,subgroup)));
      if Index(G, subgroup) <= n then
        Add(list,subgroup);
      fi;
    od;
    p := NextPrimeInt(p);
  od; 
  return list;
end;
