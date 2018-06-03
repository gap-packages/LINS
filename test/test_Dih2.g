Read("addGroup.g");
Read("findIntersections.g");
Read("tQuotient.g");
Read("pQuotient.g");
Read("main.g");

filename := "./test/test_Dih2.log";
LogTo();
LogTo(filename);

for n in [100,250,500,1000,1500] do
  ProfileFunctions([helper, AddGroup, TQuotient, PPQuotient, FindIntersections, Intersection, LowIndexSubgroupsFpGroup, Core, PreImage, Kernel, NaturalHomomorphismByNormalSubgroup, GroupHomomorphismByImagesNC, GeneratorsOfGroup, IsomorphismFpGroup, IsomorphismSimplifiedFpGroup, MTX.BasesMaximalSubmodules, PreImagesRepresentative, Image, IndexInParent, Index]);
  d := DihedralGroup(5000);
  m := LowNormalSubgroups(d, n);
  g := m[1].Group;
  normal := ForAll(m, x -> IsNormal(g, x.Group));
  #indexlist := List(m, x -> Index(g, x.Group));
  Print("\n", "DihedralGroup 5000 up to Index ", n, "\n", "  Are all groups normal: ", normal, "\n", "  How many normal groups are found: ", Length(m), "\n");
  Print("\n");
  DisplayProfile([ AddGroup, TQuotient, PPQuotient, FindIntersections, Intersection],0,0);
  Print("\n");
  DisplayProfile([ TQuotient, LowIndexSubgroupsFpGroup, Core, PreImage, IsomorphismFpGroup, Image],0,0);
  Print("\n");
  DisplayProfile([helper, PPQuotient, Kernel, NaturalHomomorphismByNormalSubgroup, GroupHomomorphismByImagesNC, GeneratorsOfGroup, IsomorphismFpGroup, IsomorphismSimplifiedFpGroup, MTX.BasesMaximalSubmodules, PreImagesRepresentative, Image, IndexInParent, Index],0,0);
  ClearProfile();
od;

LogTo();
