Read("./tests/scripts/readDependencies.g");
testname := "FreeProducts";
ToTest := [
["$C_2*C_3$", FreeProduct(CyclicGroup(2),CyclicGroup(3)), 2500, 402.630],
["$C_2*C_4$", FreeProduct(CyclicGroup(2),CyclicGroup(4)), 500, 470.730],
["$C_2*C_5$", FreeProduct(CyclicGroup(2),CyclicGroup(5)), 2000, 266.680],
["$C_2*C_6$", FreeProduct(CyclicGroup(2),CyclicGroup(6)), 500, 917.500],
["$C_2*C_7$", FreeProduct(CyclicGroup(2),CyclicGroup(7)), 1000, 46.200],
["$C_2*C_8$", FreeProduct(CyclicGroup(2),CyclicGroup(8)), 500, 2765.470],
["$C_2*C_9$", FreeProduct(CyclicGroup(2),CyclicGroup(9)), 1000, 333.740],
["$C_2*C_{10}$", FreeProduct(CyclicGroup(2),CyclicGroup(10)), 500, 243.420],
["$C_2*C_{11}$", FreeProduct(CyclicGroup(2),CyclicGroup(11)), 1000, 58.270],
["$C_2*C_{12}$", FreeProduct(CyclicGroup(2),CyclicGroup(12)), 150, 270.790]
];

for i in [1..Length(ToTest)] do
    
  Print("--------------------------------------", "\n");
  Print("Test : ", String(i), "\n");

  Read(Concatenation("./tests/magma_results/Magma", testname, String(i)));
  Read(Concatenation("./tests/latex/", testname, "/subtest", String(i), "/raw.g"));
                                                              
  g := GAP_index = MAGMA_index;
  Print("Is index the same : ", g, "\n");
  #if Length(GAP_index) <= 500 then
     GAP_supers_filtered := List([1..Length(GAP_index)], x -> Filtered(GAP_supers[x], s -> ForAny(GAP_supers[x], t -> s in GAP_supers[t]) = false));
     MAGMA_supers_filtered := List([1..Length(MAGMA_index)], x -> Filtered(MAGMA_supers[x], s -> ForAny(MAGMA_supers[x], t -> s in MAGMA_supers[t]) = false));
     b := IsCorrectResult(GAP_index, GAP_supers_filtered, MAGMA_index, MAGMA_supers_filtered);
     Print("Is Grouplattice the same : ", b, "\n"); 
  #fi;
od;
