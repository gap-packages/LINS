  #Calculate the exponent n-size vector of word
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

  #Calculate the exponent vector of word in Fp
MtoVS := function(n,p,word) 
  return List(ExponentSum(n,word),x -> x * MultiplicativeNeutralElement(FiniteField(p))); 
end;

  #Calculate the GroupHom
helper := function(GenM,p,Gens,O,Mu,Psi) 
  return List([1..Length(Gens)],i->PermList(List([1..Length(O)],j->Position(O,O[j]+(MtoVS(Length(GenM),p,Gens[i]^Mu))^Psi))));
end;


PPQuotient := function(GroupsFound, n, Current)
  local G, H, p, Iso, IH, F, GenF, ComRel, Rel, M, Mu, GenM, word, gen, gens, Mcomp, GM, MM, m, i, j, x, y, z, SGen, S, countvector, PsiHom, Q, O, GenIH, PhiHom, V, r;
  G := GroupsFound[1].Group;
  H := GroupsFound[Current].Group;
  p := 2;
  Iso := IsomorphismFpGroup(H);
  IH := Image(Iso);

  while p <= n / Index(G, H) do 
    
      # Create the Isomorphism to the group structure of the p-Module M
    Mu := EpimorphismPGroup(IH,p,1);
    M := Image(Mu);

      # Define the group action of G on the p-Module M
      # For every generator in G we store the action on M in form of a Matrix
    GenM := GeneratorsOfGroup(M);
      # If M is trivial we skip this prime
    if IsEmpty(GenM) then
      p := NextPrimeInt(p);
      continue;
    fi;
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
