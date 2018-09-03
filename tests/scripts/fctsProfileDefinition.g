BasicFcts := [LowIndexNormal, FindPQuotients, FindPModules, MustCheckP, FindTQuotients, 
FindIntersections, AddGroup];
GSubFcts := [Index, IsomorphismFpGroup, Image];
TSubFcts := [LowIndexSubgroupsFpGroup, PreImage, Core];
PSubFcts := [PQuotient, MinSubgroupSizes, IsPowerOf, EpimorphismQuotientSystem, 
PreImagesRepresentative, GeneratorsOfGroup, 
GModuleByMats, MTX.BasesMaximalSubmodules, GroupHomomorphismByImagesNC, NaturalHomomorphismBySubspace, Kernel, PullBackH, ExponentSum, NextPrimeInt];
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
