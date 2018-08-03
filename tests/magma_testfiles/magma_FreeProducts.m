/* Read the testfile from root */

testname := "MagmaFreeProducts";

RF := recformat< name : Strings(), group, max_index : Integers() >;
ToTest := [
rec<RF | name := "$C_2*C_3$", group := FreeProduct(CyclicGroup(GrpFP, 2),CyclicGroup(GrpFP, 3)), max_index := 2500>,
rec<RF | name := "$C_2*C_4$", group := FreeProduct(CyclicGroup(GrpFP, 2),CyclicGroup(GrpFP, 4)), max_index := 500>,
rec<RF | name := "$C_2*C_5$", group := FreeProduct(CyclicGroup(GrpFP, 2),CyclicGroup(GrpFP, 5)), max_index := 2000>,
rec<RF | name := "$C_2*C_6$", group := FreeProduct(CyclicGroup(GrpFP, 2),CyclicGroup(GrpFP, 6)), max_index := 500>,
rec<RF | name := "$C_2*C_7$", group := FreeProduct(CyclicGroup(GrpFP, 2),CyclicGroup(GrpFP, 7)), max_index := 1000>,
rec<RF | name := "$C_2*C_8$", group := FreeProduct(CyclicGroup(GrpFP, 2),CyclicGroup(GrpFP, 8)), max_index := 500>,
rec<RF | name := "$C_2*C_9$", group := FreeProduct(CyclicGroup(GrpFP, 2),CyclicGroup(GrpFP, 9)), max_index := 1000>,
rec<RF | name := "$C_2*C_{10}$", group := FreeProduct(CyclicGroup(GrpFP, 2),CyclicGroup(GrpFP, 10)), max_index := 500>,
rec<RF | name := "$C_2*C_{11}$", group := FreeProduct(CyclicGroup(GrpFP, 2),CyclicGroup(GrpFP, 11)), max_index := 1000>,
rec<RF | name := "$C_2*C_{12}$", group := FreeProduct(CyclicGroup(GrpFP, 2),CyclicGroup(GrpFP, 12)), max_index := 150>
];
for i in [1..#ToTest] do

  SetProfile(true);

  F := ToTest[i]`group;
  L := LowIndexNormalSubgroups(F,ToTest[i]`max_index);
  index := [x`Index : x in L];
  supers := [x`Supergroups : x in L];
  supers := [IndexedSetToSequence(SetToIndexedSet(x)) : x in supers];

  G := ProfileGraph();
  V := VertexLabels(G);
  Fcts := ["LowIndexNormalSubgroups", "FindTs", "FindPQuotients", "FindIntersections", "AddGroup"];
  Times := [];
  Counts := [];
  for j in [1..#Fcts] do
    f := [x : x in V | Fcts[j] in x`Name];
    Times[j] := f[1]`Time;
    Counts[j] := f[1]`Count;
  end for;
  total_time := Times[1];

  filename := "tests/magma_results/" cat testname cat IntegerToString(i);
  SetOutputFile(filename: Overwrite := true);
  PrintFile(filename, "MAGMA_index := ");
  PrintFile(filename, index);
  PrintFile(filename,  ";\n");
  PrintFile(filename, "MAGMA_supers := ");
  PrintFile(filename, supers);
  PrintFile(filename, ";\n");
  PrintFile(filename, "MAGMA_time := ");
  PrintFile(filename, total_time);
  PrintFile(filename, ";\n");
  PrintFile(filename, "MAGMA_fcts := ");
  PrintFile(filename, Fcts);
  PrintFile(filename, ";\n");
  PrintFile(filename, "MAGMA_times := ");
  PrintFile(filename, Times);
  PrintFile(filename, ";\n");
  PrintFile(filename, "MAGMA_counts := ");
  PrintFile(filename, Counts);
  PrintFile(filename, ";\n");
  UnsetOutputFile();
  
  ProfileReset();
end for;
