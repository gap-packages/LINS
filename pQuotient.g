PPQuotient := function(G, n, H)
  local p, Iso, IH, F, Rel, GenF, Mu, word, gen, gens, M, GM, MM, m, list, i, j, x, y, z, sub, countvector;
  list := [];
  p := 2;
  Iso := IsomorphismFpGroup(H);
  IH := Image(Iso);
  while p <= n / Index(G, H) do 
    
    # Create the Isomorphism to the p-Module M
    F := FreeGroupOfFpGroup(IH);
    Rel := [];
    GenF := GeneratorsOfGroup(F);
    for i in [1..Length(GenF)] do
      Add(Rel, GenF[i]^p);
      for j in [(i + 1)..Length(GenF)] do
        Add(Rel, Comm(GenF[i], GenF[j]) );
      od;
    od;
    M := F / Union(RelatorsOfFpGroup(IH), Rel);
    Mu := GroupHomomorphismByImages(IH, M);
    
    # Define the group action on the p-Module M
    gens := [];
    GenF := GeneratorsOfGroup(M);
    for x in GeneratorsOfGroup(G) do
      gen := [];
      for y in GeneratorsOfGroup(IH) do
        y := Image(InverseGeneralMapping(Iso),y);
        word := Image(Mu, Image(Iso, x^(-1)*y*x ));
        countvector := List([1..Length(GenF)],i -> ExponentSumWord(word![1],GeneratorsOfGroup(F)[i]));
        Add(gen, List(countvector, z -> MultiplicativeNeutralElement(FiniteField(p)) * z));
      od;
      Add(gens,gen);
    od;
    
    #Search the maximal submodules
    GM := GModuleByMats(gens, FiniteField(p));
    MM := MTX.BasesMaximalSubmodules(GM);
    for m in MM do
      sub := [];
      m := List(m, x -> List(x, Int));
      for i in [1..Length(m)] do
        x := MultiplicativeNeutralElement(M);
        for j in [1..Length(m[i])] do
          x := GenF[j]^m[i][j] * x;
        od;
        Add(sub,x);
      od; 
      sub := Image(InverseGeneralMapping(Iso),Image(InverseGeneralMapping(Mu),Subgroup(M,sub)));
      if Index(G, sub) <= n then
        Add(list,sub);
      fi;
    od;
    p := NextPrimeInt(p);
  od; 
  return list;
end;
