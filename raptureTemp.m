lib = rpLib(infile);
analysisLoadPaths();
PC = physC();
Props = loadjson('../SAMISextra/master.json');
% Set up defaults
Stack = loadjson('materialStacks/rapptureDefault.json');
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
  Stack.Chan.(strcat('group',tmp{k})) = Stack.Chan.(...
                                       strcat('group',tmp{k}))(logical(tdbl>0));
  Stack.Chan.(strcat('weights',tmp{k})) = tdbl(logical(tdbl>0));
endfor

% Doping
tmp = {'acceptor','donor'};
l = 1;
for k=l:length(tmp)
    [tstr,err] = rpLibGetString(lib,...
                                strcat('input.group(doping).group(',...
                                       tmp{k},...
                                       's).number(',...
                                       tmp{k},...
                                       '_level).current'));
    [tdbl,err]   = rpUnitsConvertDbl(tstr,'m-3');
    if (tdbl>0)
       Stack.Chan.impurities{l} = struct;
       Stack.Chan.impurities{l}.type = toupper(substr(tmp{k},1,1));
       Stack.Chan.impurities{l}.concentration = tdbl;
       [tdbl,err] = rpLibGetDouble(lib,...
                                   strcat('input.group(doping).group(',...
                                          tmp{k},...
                                          's).boolean(',...
                                          tmp{k},...
                                          '_ideal).current'));
       if (tdbl>0)
         [tstr,err] = rpLibGetString(lib,...
                                     strcat('input.group(doping).group(',...
                                            tmp{k},...
                                            's).number(',...
                                            tmp{k},...
                                            '_energy).current'));
         [Stack.Chan.impurities{l}.energy,err] = rpUnitsConvertDbl(tstr,'meV');
       endif
       l=l+1;
    endif
endfor

% Dielectric
[tstr,err] = rpLibGetString(lib,...
                            'input.group(insulator).number(ins_thick).current');
[Stack.dielectric{1}.thickness,err] = rpUnitsConvertDbl(tstr,'m');

[Stack.dielectric{1}.kappa,err] = rpLibGetDouble(lib,...
                            'input.group(insulator).number(rel_perm).current');



[err] = rpLibPutString(lib,'output.log',savejson('',Stack),1);
rpLibResult(lib);
quit;
