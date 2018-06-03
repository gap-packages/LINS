Read("addGroup.g");
Read("findIntersections.g");
Read("tQuotient.g");
Read("pQuotient.g");
Read("main.g");

filename := "./test/test_Random.log";
LogTo();
LogTo(filename);

for n in [250,500] do
  ProfileFunctions([helper, AddGroup, TQuotient, PPQuotient, FindIntersections, Intersection, LowIndexSubgroupsFpGroup, Core, PreImage, Kernel, NaturalHomomorphismByNormalSubgroupNC, GroupHomomorphismByImagesNC, GeneratorsOfGroup, IsomorphismFpGroup, IsomorphismSimplifiedFpGroup, MTX.BasesMaximalSubmodules, PreImagesRepresentative, Image, IndexInParent, Index]);
  f := FreeGroup(2);
  g := f / [f.1^2, f.2^3];
  m := LowNormalSubgroups(g, n);
  normal := ForAll(m, x -> IsNormal(g, x.Group));
  #indexlist := List(m, x -> Index(g, x));
  Print("\n", "Index up to ", n, "\n", "  Are all groups normal: ", normal, "\n", "  How many normal groups are found: ", Length(m), "\n");
  Print("\n");
  DisplayProfile([ AddGroup, TQuotient, PPQuotient, FindIntersections, Intersection],0,0);
  Print("\n");
  DisplayProfile([ TQuotient, LowIndexSubgroupsFpGroup, Core, PreImage, IsomorphismFpGroup, Image],0,0);
  Print("\n");
  DisplayProfile([helper, PPQuotient, Kernel, NaturalHomomorphismByNormalSubgroupNC, GroupHomomorphismByImagesNC, GeneratorsOfGroup, IsomorphismFpGroup, IsomorphismSimplifiedFpGroup, MTX.BasesMaximalSubmodules, PreImagesRepresentative, Image, IndexInParent, Index],0,0);
  ClearProfile();
od;

LogTo();
