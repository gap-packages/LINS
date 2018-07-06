# Start the Testfile from the root
# All Dependencies are read from a script

testname := "Example_LowIndexSubgroups";

ProfileFunctions(Concatenation(AllFcts,LowIndexSubgroupsFpGroup,IsNormal)); 

# Create the test folder
Exec(Concatenation("mkdir ", "./tests/latex/", testname));

N := [20,50];
for i in [1..Length(N)] do
  n := N[i];
  
  # Define name and maxIndex
  groupname := Concatenation("DihedralGroup(", String(2*n), ")");
  maxIndex := n;

  # Run the LowIndexNormal procedure
  g := DihedralGroup(2*n);
  m := LowIndexNormal(g, maxIndex);
  
  # Get some info from m
  normal := ForAll(m, x -> IsNormal(m[1].Group, x.Group));
  index := List(m, x -> x.Index);
  supers := List(m, x -> x.Supergroups);
  
  # Run the LowIndexSubgroups procedure
  g := m[1].Group;
  l := LowIndexSubgroupsFpGroup(g, maxIndex);
  ll := Filtered(l, x -> IsNormal(g,x));
  
  # Get some info from ll
  index2 := List(ll, x -> Index(g,x));
  supers2 := List([1..Length(ll)],i->Filtered([1..(i-1)],j->IsSubgroup(ll[j],ll[i])));

od;


