Read("addGroup.g");
Read("tQuotient.g");
Read("pQuotient.g");
Read("main.g");

filename := "./test/test_Dih2.log";
LogTo();
LogTo(filename);

for n in [100,250,500,1000,1500] do
  ProfileFunctions([helper, AddGroups, TQuotient, PPQuotient, LowIndexSubgroupsFpGroup, Core, PreImage, Kernel, NaturalHomomorphismByNormalSubgroup, GroupHomomorphismByImagesNC, GeneratorsOfGroup, IsomorphismFpGroup, IsomorphismSimplifiedFpGroup, MTX.BasesMaximalSubmodules, PreImagesRepresentative, Image, IndexInParent, Index]);
  d := DihedralGroup(5000);
  m := LowNormalSubgroups(d, n);
  g := m[1];
  normal := ForAll(m, x -> IsNormal(g, x));
  #indexlist := List(m, x -> Index(g, x));
  Print("\n", "DihedralGroup 5000 up to Index ", n, "\n", "  Are all groups normal: ", normal, "\n", "  How many normal groups are found: ", Length(m), "\n");
  Print("\n");
  DisplayProfile([ AddGroups, TQuotient, PPQuotient],0,0);
  Print("\n");
  DisplayProfile([ TQuotient, LowIndexSubgroupsFpGroup, Core, PreImage, IsomorphismFpGroup, Image],0,0);
  Print("\n");
  DisplayProfile([helper, PPQuotient, Kernel, NaturalHomomorphismByNormalSubgroup, GroupHomomorphismByImagesNC, GeneratorsOfGroup, IsomorphismFpGroup, IsomorphismSimplifiedFpGroup, MTX.BasesMaximalSubmodules, PreImagesRepresentative, Image, IndexInParent, Index],0,0);
  ClearProfile();
od;

LogTo();
