Raw := function(testname, index, supers, Fcts, normal i)
  local filename;
  
  # Specify location
  filename := Concatenation("./tests/latex/", testname, "/subtest", String(i), "/raw.g");  
  PrintTo(filename, "GAP_index := ", index, ";\n\n\n");
  AppendTo(filename, "GAP_supers := ", supers, ";\n\n\n");
  AppendTo(filename, "GAP_profile := ", ProfileInfo(Fcts, 0, 0).prof, ";");
  AppendTo(filename, "GAP_normal := ", normal, ";");
end;
