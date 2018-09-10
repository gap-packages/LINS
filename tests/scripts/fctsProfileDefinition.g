BasicFcts := [LowIndexNormal, FindPQuotients, FindPModules, MustCheckP, FindTQuotients, FindIntersections, AddGroup, MTX.BasesMaximalSubmodules, PullBackH];
GSubFcts := [Index, IsomorphismFpGroup, Image];
TSubFcts := [LowIndexSubgroupsFpGroup, PreImage, Core];
PSubFcts := [PQuotient, MinSubgroupSizes, IsPowerOf, EpimorphismQuotientSystem, 
PreImagesRepresentative, GeneratorsOfGroup, 
GModuleByMats, GroupHomomorphismByImagesNC, NaturalHomomorphismBySubspace, Kernel, ExponentSum, NextPrimeInt];
AISubFcts := [IsSubgroupFp, Intersection];
AllFcts := Concatenation(BasicFcts,GSubFcts,TSubFcts,PSubFcts,AISubFcts);

Fcts := 
[
  BasicFcts, 
  AllFcts
  #Concatenation([FindTQuotients], GSubFcts, TSubFcts),
  #Concatenation([FindPQuotients], GSubFcts, PSubFcts),
  #Concatenation([FindIntersections, AddGroup], AISubFcts)
];
