CreateLine := function(filename, line)
  local i;
  AppendTo(filename, line[1]);
  for i in [2..Length(line)] do
    AppendTo(filename, " & ", line[i]);
  od;
  AppendTo(filename, " \\\\ ", "\n");
end;

## table is read in as list of columns
CreateTable := function(testname, filename, header, table, i) 
  local j, line;
  
  # Specify location
  filename := Concatenation("./tests/latex/", testname, "/subtest", String(i), "/", filename, ".tex");
  
  # Create table layout
  AppendTo(filename, "\\begin{center}", "\n", "\\begin{longtable}[H]");
  AppendTo(filename, Concatenation("{|| ", Concatenation(List(header, x->"c ")), "||}", "\n"));
  AppendTo(filename, "\\hline", "\n");
  CreateLine(filename, header));
  AppendTo(filename, "\\hline", "\n");
  
  # Write info of each entry into the tex table
  for j in [1..Length(table[1])] do
    line := List(table,x->x[j]);
    CreateLine(filename, line));
    AppendTo(filename, "\\hline", "\n");
  od;
  
  AppendTo(filename, "\\end{longtable}", "\n", "\\end{center}", "\n");
  
end;
