CreateLine := function(line)
  local i,tmp;
  line := Concatenation(List(line, x->[x, " & "]));
  Remove(line);
  tmp := [];
  for i in [1..Length(line)] do
    Add(tmp, String(line[i]));
  od;
  line := Concatenation(tmp);
  return Concatenation(line, " \\\\ ", "\n");
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
  AppendTo(filename, CreateLine(header));
  AppendTo(filename, "\\hline", "\n");
  
  # Write info of each entry inyo the tex table
  for j in [1..Length(table[1])] do
    line := List(table,x->x[j]);
    AppendTo(filename, CreateLine(line));
    AppendTo(filename, "\\hline", "\n");
  od;
  
  AppendTo(filename, "\\end{longtable}", "\n", "\\end{center}", "\n");
  
end;
