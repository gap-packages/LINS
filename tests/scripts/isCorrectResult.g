IsCorrectResult := function(index, supers, indexCor, supersCor)
  local n, Graph, GraphCor;
  if index <> indexCor then
    return false;
  fi;
  n := Length(index);
  
  Graph := EdgeOrbitsGraph(Group( () ), Concatenation(List([1..n],i->List(supers[i],s->[s,i]))), n);
  GraphCor := EdgeOrbitsGraph(Group( () ), Concatenation(List([1..n],i->List(supersCor[i],s->[s,i]))), n);
  
  return IsIsomorphicGraph(Graph, GraphCor);
end;
