#Take an integer n, and convert it into another system (ms to s for example) in form of a string digit.
#k is the exponent of 10, and r is the number of digits, r must be smaller than k.
DRAC := function(n, k, r)
  return Concatenation( String(QuoInt(n,10^k)), ".", String(RemInt(QuoInt(n,10^(k-r)),10^r)) );
end;
