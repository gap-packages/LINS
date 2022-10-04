#############################################################################
##  createTables.gi
#############################################################################
##
##  This file is part of the LINS package.
##
##  This file's authors include Friedrich Rober.
##
##  Please refer to the COPYRIGHT file for details.
##
##  SPDX-License-Identifier: GPL-2.0-or-later
##
#############################################################################


# Info Level 1: print every entry
DeclareInfoClass( "InfoLINS_CreateTargets" );
SetInfoLevel( InfoLINS_CreateTargets, 0 );

BindGlobal("LINS_Targets_ExponentBounds",
function(T, minIndex, maxIndex)
    local minExp, maxExp;
    maxExp := 1;
    while Order(T) ^ (maxExp + 1) <= maxIndex do
        maxExp := maxExp + 1;
    od;
    minExp := 1;
    while Order(T) ^ (minExp) <= minIndex do
        minExp := minExp + 1;
    od;
    if minExp > maxExp then
        return fail;
    fi;
    return [minExp, maxExp];
end);

BindGlobal("LINS_SaveTargetsQuotients",
function(targets)
    local stream, entry, M, L, tenToL, i, t;
    stream := OutputTextFile("tmp", false);
    SetPrintFormattingStatus(stream, false);
    M := Maximum(List(targets, t -> t[1]));
    # Length of Largest Number
    L := 1;
    tenToL := 10;
    while tenToL <= M do
        L := L + 1;
        tenToL := tenToL * 10;
    od;
    for i in [1 .. Length(targets)] do
        t := targets[i];
        if i = 1 then
            AppendTo(stream, "[ ");
        else
            AppendTo(stream, "  ");
        fi;
        AppendTo(stream, "[ ", String(t[1], L), ", \"", t[2], "\", \"", t[3], "\" ]");
        if i = Length(targets) then
            AppendTo(stream, " ]\n");
        else
            AppendTo(stream, ",\n");
        fi;
    od;
end);


#############################################################################
## Computation of LINS_TargetsQuotient table from minIndex to maxIndex.
## Return the requested part of the table.
## Will compute information on all targets Inn(T^d) <= Q <= Aut(T^d)
## such that minIndex < |T|^d <= maxIndex.
#############################################################################

BindGlobal("LINS_CreateTargetsQuotient",
function(minIndex , maxIndex, UseLIS...)
    local targets, itSimple, T, boundsExp, minExp, maxExp, d, Td, factors, aut, inn, nice, hom, G, H, K, L, perms, g, images, i, j, t, Q, subgroups, S, core, entry;

    if Length(UseLIS) > 1 then
        Error("Unknown number of arguments!");
    elif Length(UseLIS) = 1 then
        UseLIS := UseLIS[1];
    else
        UseLIS := false;
    fi;

    targets := [];
    itSimple := SimpleGroupsIterator(1, maxIndex);
    for T in itSimple do

        # Establish exponent bounds.
        boundsExp := LINS_Targets_ExponentBounds(T, minIndex, maxIndex);
        if boundsExp = fail then
            continue;
        fi;
        minExp := boundsExp[1];
        maxExp := boundsExp[2];

        # Iterate trough possible exponents d.
        for d in [minExp .. maxExp] do
            Td := DirectProduct(ListWithIdenticalEntries(d, T));
            factors := List([1 .. d], i -> Image(Embedding(Td, i)));
            aut := AutomorphismGroup(Td);
            inn := InnerAutomorphismsAutomorphismGroup(aut);
            nice := NiceMonomorphism(aut);
            hom := NaturalHomomorphismByNormalSubgroup(Image(nice, aut), Image(nice, inn));
            G := Image(hom);
            L := LowIndexSubgroups(G, Order(G));
            for H in L do
                Q := PreImage(hom, H);
                K := PreImage(nice, Q);
                # Construct action of Q on direct factors
                perms := [];
                for g in GeneratorsOfGroup(K) do
                    images := [];
                    for i in [1 .. d] do
                        t := GeneratorsOfGroup(factors[i])[1] ^ g;
                        j := PositionProperty(factors, Tj -> t in Tj);
                        Add(images, j);
                    od;
                    Add(perms, PermList(images));
                od;

                # Check if action is transitive.
                if IsTransitive(Group(perms), [1..d]) then
                    if UseLIS then
                        # Search for subgroup S with small index such that Core(Q, S) is trivial.
                        subgroups := List(MaximalSubgroupClassReps(Q));
                        SortBy(subgroups, s -> Index(Q, s));
                        while not IsEmpty(subgroups) do
                            S := Remove(subgroups,1);
                            core := Core(Q,S);
                            if IsTrivial(core) then
                                entry := [Order(Q), Index(Q, S), Concatenation(Name(T),"^",String(d))];
                                Info(InfoLINS_CreateTargets, 1, entry);
                                Add(targets, entry);
                                break;
                            else
                                Append(subgroups, List(MaximalSubgroupClassReps(core)));
                                SortBy(subgroups, s -> Index(Q, s));
                            fi;
                        od;
                    else
                        entry := [Order(Q), LINS_StringGroup(Q), Concatenation(Name(T), "^", String(d))];
                        Info(InfoLINS_CreateTargets, 1, entry);
                        Add(targets, entry);
                    fi;
                fi;
            od;
        od;
    od;

    targets := DuplicateFreeList(targets);
    Sort(targets);
    return targets;
end);


#############################################################################
## Computation of LINS_TargetsCharSimple table.
## Return the requested part of the table.
## Will compute the primes dividing the schur multiplier of all groups T^d
## such that minIndex < |T|^d <= maxIndex.
## Dependent on cohomolo package.
#############################################################################

BindGlobal("LINS_CreateTargetsCharSimple",
function(minIndex, maxIndex)
    local targets, itSimple, T, boundsExp, minExp, maxExp, mult, p, d, entry;

    targets := [];
    itSimple := SimpleGroupsIterator(1, maxIndex);
    for T in itSimple do

        # Establish exponent bounds.
        boundsExp := LINS_Targets_ExponentBounds(T, minIndex, maxIndex);
        if boundsExp = fail then
            continue;
        fi;
        minExp := boundsExp[1];
        maxExp := boundsExp[2];

        # Add all primes that divide SchurMultiplier of T to mult
        mult := [];
        for p in PrimeDivisors(Order(T)) do
            if not IsEmpty(SchurMultiplier(CHR(T, p))) then
                Add(mult, p);
            fi;
        od;

        # Construct List of SchurMultipliers for groups T^d
        for d in [minExp .. maxExp] do
            entry := [Order(T) ^ d, List(mult), Concatenation(Name(T), "^", String(d))];
            Info(InfoLINS_CreateTargets, 1, entry);
            Add(targets, entry);
        od;
    od;

    Sort(targets);
    return targets;
end);
