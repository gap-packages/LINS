MainTable := function(testname, index, supers, i) 
  local filename, j;
  
  # Specify location
  filename := Concatenation("./tests/latex/", testname, "/subtest", String(i), "/main.tex");
  
  # Create table layout
  AppendTo(filename, "\\begin{center}", "\n", "\\begin{longtable}[H]");
  AppendTo(filename, "{|| c c c ||}", "\n");
  AppendTo(filename, "\\hline", "\n");
  AppendTo(filename, "Number", " &  ", "Index", " &  ", "Supergroups", "\n", "\\\\");
  AppendTo(filename, "\\hline", "\n");
  
  # Write info of each group into the table
  for j in [1..Length(index)] do
    AppendTo(filename, j, " & ", index[j], " & ", supers[j], "\n", "\\\\");
    AppendTo(filename, "\\hline", "\n");
  od;
  
  AppendTo(filename, "\\end{longtable}", "\n", "\\end{center}", "\n");
  
end;
