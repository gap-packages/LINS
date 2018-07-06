Raw := function(testname, index, supers, i)
  local filename;
  
  # Specify location
  filename := Concatenation("./tests/latex/", testname, "/subtest", String(i), "/raw.txt");  
  AppendTo(filename, index, "\n\n\n");
  AppendTo(filename, supers);
end;
