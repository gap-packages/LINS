PPQuotient := function(QQ, G, n, H)
  local p, Iso, IH, F, Rel, GenF, Mu, word, gen, gens, M, GM, MM, m, list, i, j, x, y;
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
    for x in GeneratorsOfGroup(G) do
      gen := [];
      for y in GeneratorsOfGroup(H) do
        word := Image(Mu, Image(Iso, x^(-1)*y*x ));
        Add(gen, List(Count(word,Length(GenF)), x -> MultiplicativeNeutralElement(FiniteField(p)) * x));
      od;
      Add(gens,gen);
    od;
    
    GM := GModuleByMats(gens, FiniteField(p));
    MM := MTX.BasesMaximalSubmodules(GM);
    for m in MM do
    od;
  od; 
end;
