# Start the Testfile from the root
Read("./lowIndexNormal.gd");
testname := "example";
N := [20,50];

BasicFcts := [LowIndexNormal, FindPQuotients, FindTQuotients, FindIntersections, AddGroup];
GSubFcts := [Index, IsomorphismFpGroup, Image];
TSubFcts := [LowIndexSubgroupsFpGroup, PreImage, Core];
PSubFcts := [PreImagesRepresentative, GeneratorsOfGroup, GModuleByMats, MTX.BasesMaximalSubmodules, GroupHomomorphismByImagesNC, NaturalHomomorphismBySubspace, Kernel, PullBackH, ExponentSum, NextPrimeInt];
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

ProfileFunctions(AllFcts); 

# Create the test folder
Exec(Concatenation("mkdir ", "./tests/latex/", testname));
  
for i in [1..Length(N)] do
  # Run the LowIndexNormal procedure and save the output
  n := N[i];
  d := DihedralGroup(2*n);
  m := LowIndexNormal(d, n);
  normal := ForAll(m, x -> IsNormal(m[1].Group, x.Group));
  index := List(m, x -> x.Index);
  supers := List(m, x -> x.Supergroups);
  structure := List(m, x -> StructureDescription(x.Group));
  
  ##
  ##
  ##
  ## HEADER
  ##
  ##
  ##
  
  # Specify location
  Exec(Concatenation("mkdir ", "./tests/latex/", testname, "/subtest", String(i)));
  
  # Write header
  filename := Concatenation("./tests/latex/", testname, "/subtest", String(i), "/header.tex");
  AppendTo(filename, "Group : DihedralGroup(", 2*n, ")", "\\\\", "\n");
  AppendTo(filename, "Searching up to index : ", n, "\\\\", "\n");
  AppendTo(filename, "How many normal groups are found : ", Length(m), "\\\\", "\n");
  P := ProfileInfo([LowIndexNormal],0,0);
  P := P.prof;
  AppendTo(filename, "Total Time in ms : ", P[1][2] + P[1][3], "\\\\", "\n");
  
  ##
  ##
  ##
  ## MAIN TABLE
  ##
  ##
  ##
  
  # Specify location
  filename := Concatenation("./tests/latex/", testname, "/subtest", String(i), "/main.tex");
  
  # Create table layout
  AppendTo(filename, "\\begin{center}", "\n", "\\begin{tabular}");
  AppendTo(filename, "{|| c c c ||}", "\n");
  AppendTo(filename, "\\hline", "\n");
  AppendTo(filename, "Number", " &  ", "Index", " &  ", "Supergroups", "\n", "\\\\");
  AppendTo(filename, "\\hline", "\n");
  
  # Write info of each group into the table
  for j in [1..Length(m)] do
    AppendTo(filename, j, " & ", index[j], " & ", supers[j], "\n", "\\\\");
    AppendTo(filename, "\\hline", "\n");
  od;
  
  AppendTo(filename, "\\end{tabular}", "\n", "\\end{center}", "\n");
  
  ##
  ##
  ##
  ## PROFILING TABLES
  ##
  ##
  ##
  
  for j in [1..Length(Fcts)] do
  
    # Specify location
    filename := Concatenation("./tests/latex/", testname, "/subtest", String(i), "/table", String(j), ".tex");
    
    # Create table layout
    AppendTo(filename, "\\begin{center}", "\n", "\\begin{tabular}");
    AppendTo(filename, "{|| c c c c c c ||}", "\n");
    AppendTo(filename, "\\hline", "\n");
    AppendTo(filename, "Count" , " & ", "AbsT/ms", " & ", "ChildT/ms", " & ", "AbsS/kb", " & ", "ChildS/kb", " & ", "Function", "\\\\" ,"\n");
    AppendTo(filename, "\\hline", "\n");
    
    # Get profile info of the functions
    P := ProfileInfo(Fcts[j],0,0);
    P := P.prof;
    
    # Write info of each function into the table
    for p in P do
      AppendTo(filename, p[1] , " & ", p[2] + p[3], " & ", p[3], " & ", p[4] + p[5], " & ", p[5], " & ", p[7], "\\\\", "\n");
      AppendTo(filename, "\\hline", "\n");
    od;
    
    AppendTo(filename, "\\end{tabular}", "\n", "\\end{center}", "\n");
  od;
  
  ClearProfile();
od;


