Header := function(testname, groupname, maxIndex, length, i)
  local filename, P;

  # Specify location
  Exec(Concatenation("mkdir ", "./tests/latex/", testname, "/subtest", String(i)));
  filename := Concatenation("./tests/latex/", testname, "/subtest", String(i), "/header.tex");
  
  # Write header
  PrintTo(filename, "\\textbf{", "Group : ", groupname, "}", "\\\\", "\n");
  AppendTo(filename, "Searching up to index : ", maxIndex, "\\\\", "\n");
  AppendTo(filename, "How many normal groups are found : ", length, "\\\\", "\n");
  P := ProfileInfo([LowIndexNormal],0,0);
  P := P.prof;
  AppendTo(filename, "Total Time in s : ", DRAC(P[1][2] + P[1][3],3,1), "\\\\", "\n");
  
end;
