Read("addGroup.g");
Read("tQuotient.g");
Read("pQuotient.g");
Read("main.g");

filename := "./test/test_PQuotient.log";
LogTo();
LogTo(filename);

for n in [70,155] do
  ProfileFunctions([helper, NaturalHomomorphismByNormalSubgroup, GroupHomomorphismByImagesNC, Kernel, GeneratorsOfGroup, PPQuotient, IsomorphismSimplifiedFpGroup, MTX.BasesMaximalSubmodules, PreImagesRepresentative, InverseGeneralMapping, Image, IndexInParent, Index]);
  f := FreeGroup(2);
  g := f / [f.1^2, f.2^3];
  m := LowNormalSubgroups(g, n);
  Print("\n", "Maximal Index ", n, "\n", "  How many normal groups are found: ", Length(m), "\n");
  DisplayProfile([helper, Kernel, NaturalHomomorphismByNormalSubgroup, GroupHomomorphismByImagesNC, GeneratorsOfGroup, PPQuotient, IsomorphismSimplifiedFpGroup, MTX.BasesMaximalSubmodules, PreImagesRepresentative, InverseGeneralMapping, Image, IndexInParent, Index],0,0);
  ClearProfile();
od;

LogTo();
