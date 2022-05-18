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
##  LINS_AllPrimesUpTo
#############################################################################
##  Description:
##
##  Compute all primes up to the given integer `n` via a prime sieve
##  Code snippet by @behrends
##
##  FIXME: Move me into GAP
#############################################################################

InstallGlobalFunction(LINS_AllPrimesUpTo,
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
