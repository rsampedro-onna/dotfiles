" commands to delete all texts from papers written in tex so as to generate a
" handout with only the examples and tables and stuff like that
%s/\v^\s*\n\s*(\\|\%)@!<.*\n//
%s/\v^\s*\n\s*\\(noindent|cite).*\n//
