Read("addGroup.g");
Read("tQuotient.g");
Read("pQuotient.g");
Read("main.g");

filename := "./test/test_Sym.log";
LogTo();
LogTo(filename);

for n in [5,6,7] do
  ProfileFunctions([PPQuotient,TQuotient,AddGroups]);  
  d := SymmetricGroup(n);
  m := LowNormalSubgroups(d, Factorial(n)/n/2);
  g := m[1];
  normal := ForAll(m, x -> IsNormal(g, x));
  #indexlist := List(m, x -> Index(g, x));
  Print("\n", "SymmetricGroup ", n, " up to Index ", Factorial(n)/n/2, "\n", "  Are all groups normal: ", normal, "\n", "  How many normal groups are found: ", Length(m), "\n");
  DisplayProfile([PPQuotient,TQuotient,AddGroups],0,0);
  ClearProfile();
od;

LogTo();
