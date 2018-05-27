Read("addGroup.g");
Read("tQuotient.g");
Read("pQuotient.g");
Read("main.g");

filename := "./test/test_PQuotient.log";
LogTo();
LogTo(filename);

for n in [70,155] do
  ProfileFunctions([helper,PPQuotient,IsomorphismSimplifiedFpGroup,MTX.BasesMaximalSubmodules,PreImagesRepresentative,InverseGeneralMapping,PreImage,Image,IndexInParent,Index]);
  f := FreeGroup(2);
  g := f / [f.1^2, f.2^3];
  m := LowNormalSubgroups(g, n);
  DisplayProfile([helper,PPQuotient,IsomorphismSimplifiedFpGroup,MTX.BasesMaximalSubmodules,PreImagesRepresentative,InverseGeneralMapping,PreImage,Image,IndexInParent,Index],0,0);
  ClearProfile();
od;

LogTo();
