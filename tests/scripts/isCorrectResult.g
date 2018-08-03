IsCorrectResult := function(index, supers, indexCor, supersCor)
  local n, colour, gamma, gammaCor;
  if index <> indexCor then
    return false;
  fi;
  n := Length(index);
  
  colour := Set(List([1..n],i->Filtered([1..n],j->index[i]=index[j])));
  gamma := EdgeOrbitsGraph(Group( () ), Concatenation(List([1..n],i->List(supers[i],s->[s,i]))), n);
  gamma := rec(graph:=gamma,colourClasses:=colour);
  gammaCor := EdgeOrbitsGraph(Group( () ), Concatenation(List([1..n],i->List(supersCor[i],s->[s,i]))), n);
  gammaCor := rec(graph:=gammaCor,colourClasses:=colour);
  return IsIsomorphicGraph(gamma, gammaCor);
end;
