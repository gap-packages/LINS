# FIXME: Move me into GAP
# Helper function to compute all primes up to a given integer via a prime sieve
# Code snippet by @behrends
InstallGlobalFunction(LINS_AllPrimesUpTo,
function(n)
    local i, j, sieve, result;
    if n <= 1000 then
      return Primes{[1..PositionSorted(Primes, n+1)-1]};
    fi;
    sieve := BlistList([1..n], [1..n]);
    sieve[1] := false;
    for i in [2..Int(n/2)] do
        sieve[i*2] := false;
    od;
    i := 3;
    while i * i <= n do
        if sieve[i] then
            j := 3*i;
            while j <= n do
                sieve[j] := false;
                j := j + 2*i;
            od;
        fi;
        i := i + 2;
    od;
    return ListBlist([1..n], sieve);
end);

InstallGlobalFunction(LINS_MaxPowerSmallerInt,
function(n, a)
    local i;
    i := 0;
    while a ^ (i + 1) <= n do
        i := i + 1;
    od;
    return i;
end);