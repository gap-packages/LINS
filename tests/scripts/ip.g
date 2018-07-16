IP := function(n)
  return Concatenation( String(QuoInt(n,1000)), ".", String(RemInt(QuoInt(n,100),10)) );
end;
