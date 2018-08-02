CreateTex := function(testname, n, filename, files)
  local filenamePath, i, j;
  filenamePath := Concatenation("./tests/latex/", testname, filename, ".tex");
  
  PrintTo(filenamePath, "\\documentclass{test}", "\n");
  AppendTo(filenamePath, "\\usepackage{float}", "\n");
  AppendTo(filenamePath, "\\begin{document}", "\n");
  AppendTo(filenamePath, "\\title{", testname, filename, "} \\maketitle \\noindent", "\n");
  for i in [1..n] do
    for j in [1..Length(files)] do
      AppendTo(filenamePath, "\\input{./", testname, "/subtest", String(i), "/", files[j], "}", "\n");
    od;
  od;
  AppendTo(filenamePath, "\\end{document}", "\n");
    
  Exec(Concatenation("cd ./tests/latex && latexmk -silent ", testname, filename, ".tex"));
end;
