Read("./lowIndexNormal.gd");
testname := "test_example";

BasicFcts := [LowIndexNormal, FindPQuotients, FindTQuotients, FindIntersections, AddGroup];
GSubFcts := [Index, IsomorphismFpGroup, Image];
TSubFcts := [LowIndexSubgroupsFpGroup, PreImage, Core];
PSubFcts := [PreImagesRepresentative, GeneratorsOfGroup, GModuleByMats, MTX.BasesMaximalSubmodules, GroupHomomorphismByImagesNC, NaturalHomomorphismBySubspace, Kernel, PullBackH, ExponentSum, NextPrimeInt];
AISubFcts := [IsSubgroup, Intersection];

Fcts := 
[
  BasicFcts, 
  Concatenation([FindTQuotients], GSubFcts, TSubFcts),
  Concatenation([FindPQuotients], GSubFcts, PSubFcts),
  Concatenation([FindIntersections, AddGroup], AISubFcts)
];

ProfileFunctions(Concatenation(BasicFcts,GSubFcts,TSubFcts,PSubFcts,AISubFcts)); 
N := [20,50];

Exec(Concatenation("mkdir ", "./tests/output/", testname));
  
for i in [1..Length(N)] do
  n := N[i];
  d := DihedralGroup(2*n);
  m := LowIndexNormal(d, n);
  normal := ForAll(m, x -> IsNormal(m[1].Group, x.Group));
  index := List(m, x -> x.Index);
  supers := List(m, x -> x.Supergroups);
  structure := List(m, x -> StructureDescription(x.Group));
  
  Exec(Concatenation("mkdir ", "./tests/output/", testname, "/subtest_", String(i)));
  
  filename := Concatenation("./tests/output/", testname, "/subtest_", String(i), "/main.txt");
  PrintTo(filename);
  AppendTo(filename, "Group : DihedralGroup(", 2*n, ")");
  AppendTo(filename, "Searching up to index : ", n);
  AppendTo(filename, "How many normal groups are found : ", Length(m));
  AppendTo(filename, "Are all groups normal : ", normal);
  AppendTo(filename, "The index list : ", index);
  AppendTo(filename, "The supergroup list : ", supers);
  AppendTo(filename, "The structure list : ", structure);
  
  for j in [1..Length(Fcts)] do
    filename := Concatenation("./tests/output/", testname, "/subtest_", String(i), "/table_", String(j), ".txt");
    PrintTo(filename);
    P := ProfileInfo(Fcts[j],0,0);
    P := P.prof;
    for p in P do
      AppendTo(filename, p[1], " ", p[2], " ", p[3], " ", p[4], " ", p[5], " ", p[7], "\n");
    od;
  od;
  
  ClearProfile();
od;


