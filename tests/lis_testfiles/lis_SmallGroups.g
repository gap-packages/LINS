# Start the Testfile from the root
# All Dependencies are read from a script

testname := "SmallGroups";

# Read Dependencies
Read("./tests/scripts/readDependencies.g");

Fcts := [LowIndexSubgroupsFpGroup, IsNormal];
ProfileFunctions(Fcts);

ToTest := [
["$C_2*C_7$", FreeProduct(CyclicGroup(2),CyclicGroup(7)), 1000],
["$C_2*C_{11}$", FreeProduct(CyclicGroup(2),CyclicGroup(11)), 1000],
["Dih($100$)", Image(IsomorphismFpGroup(DihedralGroup(100))), 100],
["Sym($6$)", Image(IsomorphismFpGroup(SymmetricGroup(6))),200]
];
for i in [1..Length(ToTest)] do
  
  # Definitions
  current := ToTest[i];
  groupname := current[1];
  g := current[2];
  maxIndex := current[3];
  
  # Run the LowIndexSubgroups procedure
  l := LowIndexSubgroupsFpGroup(g, maxIndex);
  ll := Filtered(l, x -> IsNormal(g,x));
  
  # Get some info from ll
  index := List(ll, x -> Index(g,x));
  supers := List([1..Length(ll)],i->Filtered([1..(i-1)],j->IsSubgroup(ll[j],ll[i])));
  P := ProfileInfo(Fcts, 0, 0).prof;
  time := DRAC(Sum(List(P,p->p[2])),3,1);
    
  # Specify location  
  filename := Concatenation("./tests/latex/lis_results/LIS", testname, String(i));  
  AppendTo(filename, "LIS_index := ", index, ";\n\n\n");
  AppendTo(filename, "LIS_supers := ", supers, ";\n\n\n");
  AppendTo(filename, "LIS_time := ", time, ";\n\n\n");
  AppendTo(filename, "LIS_profile := ", P, ";");
   
  ClearProfile();
od;
