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
  supers := List(m, x -> Filtered(x.Supergroups, s -> ForAny(x.Supergroups, t -> s in m[t].Supergroups) = false));
  
  # HEADER
  Header(testname, groupname, maxIndex, Length(m), i);
  filename := Concatenation("./tests/latex/", testname, "/subtest", String(i), "/header.tex");
  AppendTo(filename, "Total Magma-Time in s : ", current[4], "\\\\", "\n");
  
  # MAIN TABLE
  MainTable(testname, index, supers, i); 

  # PROFILING TABLES
  for j in [1..Length(Fcts)] do
    ProfileTable(testname, Fcts[j], i, j);
  od;
  
  # RAW
  Raw(testname, index, supers, i);
  
  ClearProfile();
od;


