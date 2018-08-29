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
   if i = 7 then
     continue;
   fi;
   Read(Concatenation("./tests/magma_results/Magma", testname, String(i)));
   Read(Concatenation("./tests/latex/", testname, "/subtest", String(i), "/raw.g"));                                                           
   maxIndex := ToTest[i][3];
   l := Length(Filtered(GAP_index,i->i<=maxIndex/2));                                    
   Print(l, ":");
   b := l - MAGMA_counts[3];
   Print(b, "\n");
   g := GAP_index = MAGMA_index;
   Print(g, "\n");
od;

