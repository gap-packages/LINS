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

# Computation of LINS_TargetsQuotient table from minIndex to maxIndex.
# Return the requested part of the table.
# Will compute information on all targets Inn(T^d) <= Q <= Aut(T^d)
# such that minIndex < |T|^d <= maxIndex.
InstallGlobalFunction(LINS_CreateTargetsQuotients,
function(minIndex, maxIndex)
  local targets, itSimple, T, maxExp, minExp, d, Td, factors, aut, inn, nice, canditates, perms, g, images, i, t, j, Q, subgroups, S, core, entry;
  targets := [];
  itSimple := SimpleGroupsIterator(1, maxIndex);
  for T in itSimple do

    # Establish exponent bounds.
    maxExp := 1;
    while Order(T)^(maxExp+1) <= maxIndex do
      maxExp := maxExp + 1;
    od;
    minExp := 1;
    while Order(T)^(minExp) <= minIndex do
      minExp := minExp + 1;
    od;
    if minExp > maxExp then
      continue;
    fi;

    # Iterate trough possible exponents d.
    for d in [minExp..maxExp] do

      Td := DirectProduct(List([1..d], i -> T));
      factors := List([1..d],i -> Image(Embedding(Td,i)));
      aut := AutomorphismGroup(Td);
      inn := InnerAutomorphismsAutomorphismGroup(aut);
      nice := NiceMonomorphism(aut);
      canditates := [Image(nice,aut)];
      while not IsEmpty(canditates) do
        Q := Remove(canditates);

        # Construct action of Q on direct factors
        perms := [];
        for g in GeneratorsOfGroup(PreImage(nice, Q)) do
          images := [];
          for i in [1..d] do
            t := GeneratorsOfGroup(factors[i])[1]^g;
            j := PositionProperty(factors, Ti -> t in Ti);
            Add(images, j);
          od;
          Add(perms, PermList(images));
        od;

        # Check if action is transitive.
        if IsTransitive(Group(perms), [1..d]) then

          # Add subgroups that contain the inner automorphism group as possible candidates.
          subgroups := List(MaximalSubgroupClassReps(Q));
          SortBy(subgroups, s -> Index(Q, s));
          Append(canditates, Filtered(subgroups, s -> IsSubgroup(s, Image(nice, inn))));

          # Search for subgroup S with small index such that Core(Q, S) is trivial.
          while not IsEmpty(subgroups) do
            S := Remove(subgroups,1);
            core := Core(Q,S);
            if IsTrivial(core) then
              entry := [Order(Q), Index(Q, S), Concatenation(Name(T),"^",String(d))];
              Print(entry, "\n");
              Add(targets, entry);
              break;
            else
              Append(subgroups, List(MaximalSubgroupClassReps(core)));
              SortBy(subgroups, s -> Index(Q, s));
            fi;
          od;
        fi;
      od;
    od;
  od;

  targets := DuplicateFreeList(targets);
  Sort(targets);
  return targets;
end;

# Computation of LINS_TargetsCharSimple table.
# Return the requested part of the table.
# Will compute the primes dividing the schur multiplier of all groups T^d
# such that minIndex < |T|^d <= maxIndex.
# Dependent on cohomolo package.
InstallGlobalFunction(LINS_CreateTargetsCharSimple,
function(minIndex, maxIndex)
  local targets, itSimple, T, maxExp, minExp, mult, p, d, entry;

  LoadPackage("cohomolo");
  targets := [];
  itSimple := SimpleGroupsIterator(1, maxIndex);
  for T in itSimple do

    # Establish exponent bounds.
    maxExp := 1;
    while Order(T)^(maxExp+1) <= maxIndex do
      maxExp := maxExp + 1;
    od;
    minExp := 1;
    while Order(T)^(minExp) <= minIndex do
      minExp := minExp + 1;
    od;
    if minExp > maxExp then
      continue;
    fi;

    # Add all primes that divide SchurMultiplier of T to mult
    mult := [];
    for p in PrimeDivisors(Order(T)) do
      if not IsEmpty(SchurMultiplier(CHR(T, p))) then
        Add(mult, p);
      fi;
    od;

    # Construct List of SchurMultipliers for groups T^d
    for d in [minExp..maxExp] do
      entry := [Order(T)^d, List(mult), Concatenation(Name(T),"^",String(d))];
      Print(entry, "\n");
      Add(targets, entry);
    od;
  od;

  Sort(targets);
  return targets;
end;
