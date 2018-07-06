ProfileTable := function(testname, Fcts, i, j)
    local filename, P, p;
    
    # Specify location
    filename := Concatenation("./tests/latex/", testname, "/subtest", String(i), "/table", String(j), ".tex");
    
    # Create table layout
    AppendTo(filename, "\\begin{center}", "\n", "\\begin{longtable}[H]");
    AppendTo(filename, "{|| c c c c c c ||}", "\n");
    AppendTo(filename, "\\hline", "\n");
    AppendTo(filename, "Count" , " & ", "AbsT/ms", " & ", "ChildT/ms", " & ", "AbsS/kb", " & ", "ChildS/kb", " & ", "Function", "\\\\" ,"\n");
    AppendTo(filename, "\\hline", "\n");
    
    # Get profile info of the functions
    P := ProfileInfo(Fcts,0,0);
    P := P.prof;
    
    # Write info of each function into the table
    for p in P do
      AppendTo(filename, p[1] , " & ", p[2] + p[3], " & ", p[3], " & ", p[4] + p[5], " & ", p[5], " & ", p[7], "\\\\", "\n");
      AppendTo(filename, "\\hline", "\n");
    od;
    
    AppendTo(filename, "\\end{longtable}", "\n", "\\end{center}", "\n");
    
end;
