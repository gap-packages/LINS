# Start the Testfile from the root
# All Dependencies are read from a script

testname := "Example";

ProfileFunctions(AllFcts); 

# Create the test folder
Exec(Concatenation("rm -r -f ", "./tests/latex/", testname));
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
  supers := List(m, x -> Filtered(x.Supergroups, s -> ForAny(x.Supergroups, t -> s in m[t].Supergroups) = false));
  
  # HEADER
  Header(testname, groupname, maxIndex, Length(m), i);
  
  # RAW
  Raw(testname, index, supers, i);
  
  # MAIN TABLE
  MainTable(testname, index, supers, i); 

  # PROFILING TABLES
  for j in [1..Length(Fcts)] do
    ProfileTable(testname, Fcts[j], i, j);
  od;
  
  ClearProfile();
od;


