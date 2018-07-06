BasicFcts := [LowIndexNormal, FindPQuotients, FindTQuotients, FindIntersections, AddGroup];
GSubFcts := [Index, IsomorphismFpGroup, Image];
TSubFcts := [LowIndexSubgroupsFpGroup, PreImage, Core];
PSubFcts := [EpimorphismPGroup, PreImagesRepresentative, GeneratorsOfGroup, GModuleByMats, MTX.BasesMaximalSubmodules, GroupHomomorphismByImagesNC, NaturalHomomorphismBySubspace, Kernel, PullBackH, ExponentSum, NextPrimeInt];
AISubFcts := [IsSubgroup, Intersection];
AllFcts := Concatenation(BasicFcts,GSubFcts,TSubFcts,PSubFcts,AISubFcts);

Fcts := 
[
  BasicFcts, 
  AllFcts
  #Concatenation([FindTQuotients], GSubFcts, TSubFcts),
  #Concatenation([FindPQuotients], GSubFcts, PSubFcts),
  #Concatenation([FindIntersections, AddGroup], AISubFcts)
];
