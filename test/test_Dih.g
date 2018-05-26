Read("addGroup.g");
Read("tQuotient.g");
Read("pQuotient.g");
Read("main.g");

filename := "./test/test_Dih.log";
LogTo();
LogTo(filename);

for n in [10,50,250,500] do
  ProfileFunctions([PPQuotient,TQuotient,AddGroups]);  
  d := DihedralGroup(2*n);
  m := LowNormalSubgroups(d, n);
  g := m[1];
  normal := ForAll(m, x -> IsNormal(g, x));
  #indexlist := List(m, x -> Index(g, x));
  Print("\n", "DihedralGroup ", 2*n, "\n", "  Are all groups normal: ", normal, "\n", "  How many normal groups are found: ", Length(m), "\n");
  structure := List(m, StructureDescription);
  View(m);
  DisplayProfile([PPQuotient,TQuotient,AddGroups],0,0);
  ClearProfile();
od;

LogTo();
