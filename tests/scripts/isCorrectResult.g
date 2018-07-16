IsCorrectResult := function(index, supers, indexCor, supersCor)
  local i, j, A, B, C, a, b, isBij;
  
  # Is index equal
  if index <> indexCor then
    return false;
  fi;
  
  # Is supers equal
  i := 1;
  while i <= Length(index) do
    # Calculate position j, such that index at position i to j is equal
    j := i;
    while (j < Length(index) and index[j+1] = index[i]) do
      j := j + 1;
    od;
    # Filter Supergroups of subgroups with the same index
    A := List([i..j], s -> supers[s]);
    B := List([i..j], s -> supersCor[s]);
    # Is there a bijection between A and B
    for a in A do
      isBij := false;
      C := [];
      for b in B do
        if (isBij = false and IsEqualSet(a,b)) then
          isBij := true;
          continue;
        fi;
        Add(C,b);
      od;
      B := C;
      if isBij = false then
        return false;
      fi;
    od;    
    i := j + 1;
  od;
  
  return true;
end;
