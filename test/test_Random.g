Read("addGroup.g");
Read("tQuotient.g");
Read("pQuotient.g");
Read("main.g");

filename := "./test/test_Random.log";
LogTo();
LogTo(filename);

for n in [10,50,70,100,125] do
  ProfileFunctions([PPQuotient,TQuotient,AddGroups]);
  f := FreeGroup(2);
  g := f / [f.1^2, f.2^3];
  m := LowNormalSubgroups(g, n);
  normal := ForAll(m, x -> IsNormal(g, x));
  #indexlist := List(m, x -> Index(g, x));
  Print("\n", "Index up to ", n, "\n", "  Are all groups normal: ", normal, "\n", "  How many normal groups are found: ", Length(m), "\n");
  DisplayProfile([PPQuotient,TQuotient,AddGroups],0,0);
  ClearProfile();
od;

LogTo();
