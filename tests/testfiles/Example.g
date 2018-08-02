# Start the Testfile from the root

testname := "Example";

# Read Dependencies
Read("./tests/scripts/readDependencies.g");

ProfileFunctions(AllFcts);;

# Create the test folder
Exec(Concatenation("rm -r -f ", "./tests/latex/", testname));
Exec(Concatenation("mkdir ", "./tests/latex/", testname));

N := [20,50];
for i in [1..Length(N)] do
  n := N[i];
  
  # Definitions
  groupname := Concatenation("DihedralGroup(", String(2*n), ")");
  maxIndex := n;

  # Run the LowIndexNormal procedure and save the output
  g := DihedralGroup(2*n);
  m := LowIndexNormal(g, maxIndex);
  
  # Calculate information about normal subgroups
  normal := ForAll(m, x -> IsNormal(m[1].Group, x.Group));
  index := List(m, x -> x.Index);
  supers := List(m, x -> Filtered(x.Supergroups, s -> ForAny(x.Supergroups, t -> s in m[t].Supergroups) = false));
  
  # HEADER
  Header(testname, groupname, maxIndex, Length(m), i);
   
  # MAIN TABLE
  CreateTable(testname, "GroupLattice", 
  ["Number", "Index", "Supergroups"], 
  [[1..Length(index)], index, supers], i);

  # PROFILING TABLES
  for j in [1..Length(Fcts)] do
    CreateTable(testname, Concatenation("Table", String(j)), 
    ["Count", "AbsT/s", "ChildT/s", "AbsS/gb", "ChildS/gb", "Function"], ProfileTable(Fcts[j],3,6), i);
  od;
  
  # RAW
  Raw(testname, index, supers, i);
  
  ClearProfile();
od;

CreateTex(testname, Length(N), "GroupLattice", ["header", "GroupLattice"]);
CreateTex(testname, Length(N), "BasicProfile", ["header", "Table1"]);
CreateTex(testname, Length(N), "ExtendedProfile", ["header", "Table2"]);
