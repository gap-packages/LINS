Header := function(testname, groupname, maxIndex, length, i)
  local filename, P;

  # Specify location
  Exec(Concatenation("mkdir ", "./tests/latex/", testname, "/subtest", String(i)));
  filename := Concatenation("./tests/latex/", testname, "/subtest", String(i), "/header.tex");
  
  # Write header
  AppendTo(filename, "\\textbf{", "Group : ", groupname, "}", "\\\\", "\n");
  AppendTo(filename, "Searching up to index : ", maxIndex, "\\\\", "\n");
  AppendTo(filename, "How many normal groups are found : ", length, "\\\\", "\n");
  P := ProfileInfo([LowIndexNormal],0,0);
  P := P.prof;
  AppendTo(filename, "Total Time in ms : ", P[1][2] + P[1][3], "\\\\", "\n");
  
end;
