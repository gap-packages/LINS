ProfileTable := function(testname, Fcts, i, j)
    local filename, P, p;
    
    # Specify location
    filename := Concatenation("./tests/latex/", testname, "/subtest", String(i), "/table", String(j), ".tex");
    
    # Create table layout
    AppendTo(filename, "\\begin{center}", "\n", "\\begin{longtable}[H]");
    AppendTo(filename, "{|| c c c c c c ||}", "\n");
    AppendTo(filename, "\\hline", "\n");
    AppendTo(filename, "Count" , " & ", "AbsT/s", " & ", "ChildT/s", " & ", "AbsS/mb", " & ", "ChildS/mb", " & ", "Function", "\\\\" ,"\n");
    AppendTo(filename, "\\hline", "\n");
    
    # Get profile info of the functions
    P := ProfileInfo(Fcts,0,0);
    P := P.prof;
    
    # Write info of each function into the table
    for p in P do
      AppendTo(filename, p[1] , " & ", IP(p[2] + p[3]), " & ", IP(p[3]), " & ", IP(p[4] + p[5]), " & ", IP(p[5]), " & ", p[7], "\\\\", "\n");
      AppendTo(filename, "\\hline", "\n");
    od;
    
    AppendTo(filename, "\\end{longtable}", "\n", "\\end{center}", "\n");
    
end;
