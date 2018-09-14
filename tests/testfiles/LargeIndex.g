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
["$C_2*C_3$", FreeProduct(CyclicGroup(2),CyclicGroup(3)), 10000],
["$C_2*C_8$", FreeProduct(CyclicGroup(2),CyclicGroup(8)), 10000],
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
  Raw(testname, index, supers, Fcts[2], normal, i);
   
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
  MAGMA_time := DRAC_MAGMA(MAGMA_time);
  MAGMA_times := List(MAGMA_times, t->DRAC_MAGMA(t));
  PrintTo(Concatenation("./tests/latex/", testname, "/subtest", String(i), "/CompareMagmaHeader"), "Total Time (in s) in MAGMA", MAGMA_time);
  P := ProfileTable(Fcts[1],3,6);
  CreateTable(testname, "CompareMagma",
  ["Function", "Count_GAP", "Count_MAGMA", "Time_GAP", "Time_MAGMA"], CompareTable(P[1], P[2], P[3], MAGMA_fcts, MAGMA_counts, MAGMA_times), i);
  
  ClearProfile();
od;

CreateTex(testname, Length(ToTest), "GroupLattice", ["header", "GroupLattice"]);
CreateTex(testname, Length(ToTest), "BasicProfile", ["header", "Table1"]);
CreateTex(testname, Length(ToTest), "ExtendedProfile", ["header", "Table2"]);
CreateTex(testname, Length(ToTest), "ComparisonMagma", ["header", "CompareMagmaHeader", "CompareMagma"]);
