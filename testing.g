ProfileTable2 := function(P, k, l)
  local T;
  T := [];
  
  # Populate List with raw data
  T[1] := List(P, p->p[7]);
  T[2] := List(P, p->p[1]);
  T[3] := List(P, p->p[2] + p[3]);
  T[4] := List(P, p->p[3]);
  T[5] := List(P, p->Int( (p[4] + p[5]) / 1024 ));
  T[6] := List(P, p->Int( p[5] / 1024 ));

  
  # Convert raw data
  T[3] := List(T[3], x->DRAC(x,k,1));
  T[4] := List(T[4], x->DRAC(x,k,1));
  T[5] := List(T[5], x->DRAC(x,l,1));
  T[6] := List(T[6], x->DRAC(x,l,1));
  return T;
end;

testname := "FreeProducts";
Read("./tests/scripts/readDependencies.g");
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
   
  P := ProfileTable2(GAP_profile,3,6); 
  GAP_fcts := P[1];
  GAP_times := P[3];
  GAP_names := ["LowIndexNormal", "FindPQuotients", "FindTQuotients", "FindIntersections", "AddGroup"];
  MAGMA_names := [ "LowIndexNormalSubgroups", "FindPQuotients", "FindTs", "FindIntersections", "AddGroup"];
  GAP_sort := List(GAP_names, x->Position(GAP_fcts,x));
  MAGMA_sort := List(MAGMA_names, x->Position(MAGMA_fcts,x));
  Print("FindPQuotients without AddGroup in GAP : ", Float(GAP_times[GAP_sort[2]]) - Float(GAP_times[GAP_sort[5]]), "\n"); 
  Print("FindPQuotients in MAGMA : ", Float(MAGMA_times[MAGMA_sort[2]]), "\n"); 
  Print("AddGroups in GAP : ", GAP_times[GAP_sort[5]], "\n"); 
  Print("AddGroups in MAGMA : ", MAGMA_times[MAGMA_sort[5]], "\n"); 
od;

