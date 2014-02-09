lib = rpLib(infile);
A = zeros(3,1);
B = zeros(3,1);

[A(1),err] = rpLibGetDouble(lib,'input.group(composition).group(group_a).number(Al).current');
[A(2),err] = rpLibGetDouble(lib,'input.group(composition).group(group_a).number(Ga).current');
[A(3),err] = rpLibGetDouble(lib,'input.group(composition).group(group_a).number(In).current');
[B(1),err] = rpLibGetDouble(lib,'input.group(composition).group(group_b).number(P).current');
[B(2),err] = rpLibGetDouble(lib,'input.group(composition).group(group_b).number(As).current');
[B(3),err] = rpLibGetDouble(lib,'input.group(composition).group(group_b).number(Sb).current');


[err] = rpLibPutString(lib,'output.log',sprintf('\nGroup III: %g',sum(A)),1);
[err] = rpLibPutString(lib,'output.log',sprintf('\nGroup V: %g',sum(B)),1);
rpLibResult(lib);
quit;
