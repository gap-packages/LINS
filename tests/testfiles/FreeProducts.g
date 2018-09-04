# Start the Testfile from the root
# All Dependencies are read from a script

testname := "FreeProducts";

# Read Dependencies
Read("./tests/scripts/readDependencies.g");

ProfileFunctions(AllFcts);

# Create the test folder
Exec(Concatenation("rm -r -f ", "./tests/latex/", testname));
Exec(Concatenation("mkdir ", "./tests/latex/", testname));

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
  
  # Definitions
  current := ToTest[i];
  groupname := current[1];
  g := current[2];
  maxIndex := current[3];

  # Run the LowIndexNormal procedure and save the output
  m := LowIndexNormal(g, maxIndex);
  
  # Calculate information about normal subgroups
  normal := ForAll(m, x -> IsNormal(m[1].Group, x.Group));
  index := List(m, x -> x.Index);
  supers := List(m, x -> x.Supergroups);
  supers_filtered := List(m, x -> Filtered(x.Supergroups, s -> ForAny(x.Supergroups, t -> s in m[t].Supergroups) = false));
  
  # HEADER
  Header(testname, groupname, maxIndex, Length(m), i);
  
  # RAW
  Raw(testname, index, supers, Fcts[2], i);
   
  # MAIN TABLE
  CreateTable(testname, "GroupLattice", 
  ["Number", "Index", "Supergroups"], 
  [[1..Length(index)], index, supers_filtered], i);

  # PROFILING TABLES
  for j in [1..Length(Fcts)] do
    CreateTable(testname, Concatenation("Table", String(j)), 
    ["Function", "Count", "AbsT/s", "ChildT/s", "AbsS/gb", "ChildS/gb"], ProfileTable(Fcts[j],3,6), i);
  od;
  
  # COMPARISON MAGMA
  Read(Concatenation("./tests/magma_results/Magma", testname, String(i)));
  P := ProfileTable(Fcts[1],3,6);
  ##filename := Concatenation("./tests/latex/", testname, "/subtest", String(i), "/compare.tex");
  ##PrintTo(filename, "Total Time in s in MAGMA: ", MAGMA_time, "\\\\", "\n");
  ##MAGMA_supers_filtered := List([1..Length(MAGMA_index)], x -> Filtered(MAGMA_supers[x], s -> ForAny(MAGMA_supers[x], t -> s in MAGMA_supers[t]) = false));
  ##AppendTo(filename, "Are results equal: ", IsCorrectResult(index, supers_filtered, MAGMA_index, MAGMA_supers_filtered), "\\\\", "\n");
  CreateTable(testname, "CompareMagma",
  ["Function", "Count_GAP", "Count_MAGMA", "Time_GAP", "Time_MAGMA"], CompareTable(P[1], P[2], P[3], MAGMA_fcts, MAGMA_counts, MAGMA_times), i);
  
  ClearProfile();
od;

CreateTex(testname, Length(ToTest), "GroupLattice", ["header", "GroupLattice"]);
CreateTex(testname, Length(ToTest), "BasicProfile", ["header", "Table1"]);
CreateTex(testname, Length(ToTest), "ExtendedProfile", ["header", "Table2"]);
CreateTex(testname, Length(ToTest), "ComparisonMagma", ["header", "CompareMagma"]);

