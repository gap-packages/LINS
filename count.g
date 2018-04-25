Count := function(word, n)
  local wordString, bracket, gen, sign, numb, vector, i, c;
  
  wordString := StringFactorizationWord(word);
  vector := ListWithIdenticalEntries(n, 0);
  bracket := false;
  gen := [];
  sign := [];
  numb := 0;
  Add(wordString,'f');
  for c in wordString do
    if c = '(' then
      continue;
    fi;
    if c = ')' then
      bracket := true;
    fi;
    
    if bracket = true then
      if IsAlphaChar(c) then
        for i in [1..Length(gen)] do
          vector[gen[i]] := vector[gen[i]] + sign[i] * numb;
        od;
        numb := 0;
        gen := [];
        sign := [];
        bracket := false;
      fi;
      if IsDigitChar(c) then
        numb := numb * 10 + (IntChar(c) - 48);
      fi;
    fi;
    
    if bracket = false then
      if IsAlphaChar(c) then
        if numb <> 0 then
          Add(gen, numb);
          numb := 0;
        fi;
        if IsLowerAlphaChar(c) then
          Add(sign,-1);
        fi;
        if IsUpperAlphaChar(c) then
          Add(sign,1);
        fi;
      fi;
      if IsDigitChar(c) then
        numb := numb * 10 + (IntChar(c) - 48);
      fi;
    fi;
  od;
  
  if IsEmpty(gen) = false then
    for i in [1..Length(gen)] do
      vector[gen[i]] := vector[gen[i]] + sign[i];
    od;
  fi;
  return vector;
end;
