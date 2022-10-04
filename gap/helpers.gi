#############################################################################
##  helpers.gi
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


#############################################################################
####=====================================================================####
##
## Primes
##
####=====================================================================####
#############################################################################


#############################################################################
##  LINS_AllPrimesUpTo
#############################################################################
##  Description:
##
##  Compute all primes up to the given integer `n` via a prime sieve
##  Code snippet by @behrends
##
##  FIXME: Move me into GAP
#############################################################################

BindGlobal("LINS_AllPrimesUpTo",
function(n)
    local i, j, sieve, result;
    if n <= 1000 then
      return Primes{[1 .. PositionSorted(Primes, n + 1) - 1]};
    fi;
    sieve := BlistList([1 .. n], [1 .. n]);
    sieve[1] := false;
    for i in [2 .. Int(n / 2)] do
        sieve[i * 2] := false;
    od;
    i := 3;
    while i * i <= n do
        if sieve[i] then
            j := 3 * i;
            while j <= n do
                sieve[j] := false;
                j := j + 2 * i;
            od;
        fi;
        i := i + 2;
    od;
    return ListBlist([1 .. n], sieve);
end);


#############################################################################
####=====================================================================####
##
## LINS Target Tables
##
####=====================================================================####
#############################################################################


#############################################################################
##  LINS_StringGroup
#############################################################################
##  Description:
##
##  Tranform a group into a string representation
#############################################################################
BindGlobal("LINS_StringGroup",
function(G)
    local rep, gens, rels, F, R, i, j;
    if IsPermGroup(G) or IsMatrixGroup(G) then
        rep := String(GeneratorsOfGroup(G));
    elif IsFpGroup(G) then
        gens := GeneratorsOfGroup(G);
        rels := RelatorsOfFpGroup(G);
        F := List([1 .. Length(gens)], i -> Concatenation("F.", String(i)));
        R := List(rels, LetterRepAssocWord);
        rep := Concatenation(String(Length(F)), " | ", String(R));
    else
        Error("Unsupported representation of group!");
    fi;
    return rep;
end);

#############################################################################
##  LINS_GroupString
#############################################################################
##  Description:
##
##  Tranform a string representation into a group
#############################################################################
BindGlobal("LINS_GroupString",
function(rep)
    local G, L, n, F, R;
    L := SplitString(rep, "|");
    # Group is given by generators
    if Length(L) = 1 then
        G := Group(EvalString(rep));
    # Group is given by relators
    elif Length(L) = 2 then
        n := EvalString(L[1]);
        F := FreeGroup(n);
        R := List(EvalString(L[2]), word -> AssocWordByLetterRep(FamilyObj(F.1), word));
        G := F / R;
    else
        Error("Unsupported representation of group!");
    fi;
    return G;
end);

#############################################################################
##  LINS_TransformTargets
#############################################################################
##  Description:
##
##  Tranform an entry of the targets list
#############################################################################
BindGlobal("LINS_TransformTargets",
function(entry)
    entry[2] := LINS_GroupString(entry[2]);
    return entry;
end);
