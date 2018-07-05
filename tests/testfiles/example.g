# Start the Testfile from the root

testname := "example";

ProfileFunctions(AllFcts); 

# Create the test folder
Exec(Concatenation("mkdir ", "./tests/latex/", testname));

N := [20,50];
for i in [1..Length(N)] do
  n := N[i];
  
  #Define name and maxIndex
  groupname := Concatenation("DihedralGroup(", String(2*n), ")");
  maxIndex := n;

  # Run the LowIndexNormal procedure and save the output
  g := DihedralGroup(2*n);
  m := LowIndexNormal(g, maxIndex);
  
  #Get some info from m
  normal := ForAll(m, x -> IsNormal(m[1].Group, x.Group));
  index := List(m, x -> x.Index);
  supers := List(m, x -> x.Supergroups);
  #structure := List(m, x -> StructureDescription(x.Group));
  
  # HEADER
  Header(testname, groupname, maxIndex, Length(m), i);
  
  # MAIN TABLE
  MainTable(testname, index, supers, i); 

  # PROFILING TABLES
  for j in [1..Length(Fcts)] do
    ProfileTable(testname, Fcts[j], i, j);
  od;
  
  ClearProfile();
od;


