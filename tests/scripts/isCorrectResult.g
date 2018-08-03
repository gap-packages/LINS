IsCorrectResult := function(index, supers, indexCor, supersCor)
  local i, j, n, F, FF, a, b, FA, FAB, f, fa, fab;
  
  # Is index equal
  if index <> indexCor then
    return false;
  fi;
  
  # Try to find a bijection f : [1..n] -> [1..n]
  # such that for every 1 <= i <= l
  # we have supers[i] = f(supers[f(i)]) and index[i] = index[f(i)].
  # The permutation f is a permutation of positions of the groups in the two lists.
  # f(i) = 0 means not defined.
  n := Length(index);
  F := [List([1..n],x->0)];
  
  i := 1;
  while i <= Length(index) do
  
    # Calculate position j, such that index at position i to j is equal
    j := i;
    while (j < n and index[j+1] = index[i]) do
      j := j + 1;
    od;
        
    # FF stores every extension of f in F on [i..j]
    FF := [];
    # f is defined to i-1, try to extend to j.
    for f in F do

      # Try to find extensions of f for each value a in [i..j].
      # FA stores current extensions of f, which are defined to a-1.
      FA := [f];
      for a in [i..j] do
      
        # FAB stores current extension of f, where the value of a is defined.
        FAB := [];
        for fa in FA do
          for b in [i..j] do
          
            # This is a possible extension of f
            if not (b in fa) and IsEqualSet(List(supers[a],x->fa[x]),supersCor[b]) then
              fab := Concatenation([],fa);
              fab[a] := b;
              Add(FAB,fab);
            fi;
          od;
        od; 
        # Update FA
        FA := Concatenation([],FAB);
      od; 
      # Update FF
      FF := Concatenation(FF,FA);  
    od;
    # Update F
    F := Concatenation([],FF);
    i := j + 1;
  od;
  
  # return statement
  if IsEmpty(F) 
  then
    return false;
  else
    return true;
  fi;
end;
