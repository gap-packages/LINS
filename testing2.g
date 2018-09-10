Read("./tests/scripts/readDependencies.g");
testname := "SomeName";
# Number of subtests
n := 1;

for i in [1..n] do
    
  Print("--------------------------------------", "\n");
  Print("Test : ", String(i), "\n");

  Read(Concatenation("./tests/magma_results/Magma", testname, String(i)));
  Read(Concatenation("./tests/latex/", testname, "/subtest", String(i), "/raw.g"));
                                                              
  g := GAP_index = MAGMA_index;
  Print("Is index the same : ", g, "\n");
  if Length(GAP_index) <= 800 then
     GAP_supers_filtered := List([1..Length(GAP_index)], x -> Filtered(GAP_supers[x], s -> ForAny(GAP_supers[x], t -> s in GAP_supers[t]) = false));
     MAGMA_supers_filtered := List([1..Length(MAGMA_index)], x -> Filtered(MAGMA_supers[x], s -> ForAny(MAGMA_supers[x], t -> s in MAGMA_supers[t]) = false));
     b := IsCorrectResult(GAP_index, GAP_supers_filtered, MAGMA_index, MAGMA_supers_filtered);
     Print("Is Grouplattice the same : ", b, "\n"); 
  fi;
od;
