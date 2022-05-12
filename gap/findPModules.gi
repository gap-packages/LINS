#############################################################################
##
##  This file is part of LINS, a package for the GAP computer algebra system
##  which provides a method for the computation of normal subgroups in a
##  finitely presented group.
##
##  This files's authors include Friedrich Rober.
##
##  SPDX-License-Identifier: GPL-3.0-or-later
##
#############################################################################


##
## Calculate the exponent sum n-size vector of word in Fp
##
InstallGlobalFunction(LINS_ExponentSum, function(n,p,word)
  local
    rep,      # exponent Representaton of word, that are tupels (a,b), such that a^b is a subword of word
    i,        # loop variable
    res;      # exponent sum n-size vector of word
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
InstallGlobalFunction(LINS_PullBackH, function(GenM,p,Gens,O,Mu,Psi)
  return List([1..Length(Gens)],i->PermList(List([1..Length(O)],j->Position(O,O[j]+(LINS_ExponentSum(Length(GenM),p,Gens[i]^Mu))^Psi))));
end);

##
## maximal Generators of the PQuotient.
##
BindGlobal("LINS_maxPGenerators", 1000);

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
InstallGlobalFunction(LINS_FindPModules, function(GroupsFound, n, Current, p)
  local
    G,        # the parent group, which is stored at the first position in GroupsFound
    H,        # the group (record) at position Current
    Iso,      # isomorphism from H into fp-group
    IH,       # fp-group, image of Iso
    P,        # p-quotient of IH of class 1
    Mu,       # epimorphism from IH into P
    M,        # pc-group, image of Mu
    GenM,     # generators of M, basis of Fp-G module M
    gens,     # list of matrices, action of generators of G on M
    x,        # loop variable, generator of G
    y,        # loop variable, generator of M identified by Mu and Iso with word in H
    word,     # word in M, y^x via a "conjugation" action of G on M
    gen,      # Fp-matrix, action of some generator of G on M
    GM,       # MeatAxe module, representation of Fp-G module M by gens
    MM,       # list of maximal modules of GM
    m,        # loop variable, maximal module
    V,        # Vectorspace Fp^n, where n is the dimension of GM
    r,        # index of m in V, which equals index of K in H
    PsiHom,   # epimorphism from V to V/m
    Q,        # vector space, image of PsiHom
    O,        # elements of Q
    GenIH,    # generators of IH
    PhiHom,   # epimorphism from H into p-quotient H/K, identification of Q as a quotient of H via Mu
    K,        # subgroup of H with p-quotient, normal in G
    NewGroup; # record (list, position) after inserting K into GroupsFound

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
      Add(gen, LINS_ExponentSum(Length(GenM),p,word));
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
    PhiHom :=  GroupHomomorphismByImagesNC(H,SymmetricGroup(Length(O)),LINS_PullBackH(GenM,p,List(GeneratorsOfGroup(H),x->Image(Iso,x)),O,Mu,PsiHom));
    K := Kernel(PhiHom);

    # Add the subgroup K by calling the LINS_AddGroup-function
    if Index(G, K) <= n then
      NewGroup := LINS_AddGroup(GroupsFound,K,SSortedList([1,Current]),true);
      GroupsFound := NewGroup[1];
      # If the index is sufficient small, compute p-Quotients from the subgroup K
      if p <= n / Index(G, K) then
        GroupsFound := LINS_FindPModules(GroupsFound, n, NewGroup[2], p);
      fi;
    fi;
  od;

  return GroupsFound;
end);
