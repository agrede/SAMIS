lib = rpLib(infile);
analysisLoadPaths();
PC = physC();

% Set up defaults
Stack = loadjson('../SAMISextra/master.json');
Stack.Chan.impurities = cell;

% Composition
tmp = {'A','B'};
for k=1:length(tmp)
  tdbl = zeros(1,3);
  tmplc = tolower(tmp{k});
  elmnts = Stack.Chan.(strcat('group',tmp{k}));
  for l=1:length(elmnts)
    [tdbl(l),err] = rpLibGetDouble(lib, ...
                              strcat('input.group(composition).group(group_',...
                                     tmplc,').number(',elmnts{l},').current'));
  endfor
  Stack.Chan.(strcat('group',tmp{k})) = Stack.Chan.(strcat('group',tmp{k}))(logical(tdbl>0));
  Stack.Chan.(strcat('weights',tmp{k})) = tdbl(logical(tdbl>0));
endfor

tmp = {'acceptor','donor'};
l = 1;
for k=l:length(tmp)
    [tstr,err] = rpLibGetString(lib,...
                                strcat('input.group(doping).group(',...
                                       tmp{l},...
                                       's).number(',...
                                       tmp{l},...
                                       '_level).current'));
    [tdbl,err]   = rpUnitsConvertDbl(tstr,'m-3');
    if (tdbl>0)
       Stack.Chan.impurities{l} = struct;
       Stack.Chan.impurities{l}.type = toupper(substr(tmp{k},1,1));
       Stack.Chan.impurities{l}.concentration = tdbl;
       [tdbl,err] = rpLibGetDouble(lib,...
                                   strcat('input.group(doping).group(',...
                                          tmp{l},...
                                          's).boolean(',...
                                          tmp{l},...
                                          '_ideal).current'));
       if (tdbl>0)
         [tstr,err] = rpLibGetString(lib,...
                                     strcat('input.group(doping).group(',...
                                            tmp{l},...
                                            's).number(',...
                                            tmp{l},...
                                            '_energy).current'));
         [Stack.Chan.impurities{l}.energy,err]   = rpUnitsConvertDbl(tstr,'meV');
       endif
       l=l+1;
    endif
endfor

[err] = rpLibPutString(lib,'output.log',sprintf('\nGroup III: %g',sum(A)),1);
[err] = rpLibPutString(lib,'output.log',sprintf('\nGroup V: %g',sum(B)),1);
[err] = rpLibPutString(lib,'output.log',sprintf('\nNA: %e',NA),1);
rpLibResult(lib);
quit;
