% GUI backend for Rappture
%
% Rappture documentation available at http://rapture.org
%
% Copyright (C) 2013--2016 Alex J. Grede
% GPL v3, See LICENSE.txt for details
% This function is part of SAMIS (https://github.com/agrede/SAMIS)
lib = rpLib(infile);
pkg load gsl;
%analysisLoadPaths; %only for debuging
PC = physC();
Props = loadjson('master.json');
% Set up defaults
Stack = loadjson('rapptureDefault.json');
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
tmp = {'acceptors','donors'};
dopants = {};
l = 1;
for k=1:length(tmp)
  pth = strcat('input.group(doping).group(',tmp{k},').');
  [tstr,err] = rpLibGetString(lib,strcat(pth,'number(concentration).current'));
  [tdbl,err]   = rpUnitsConvertDbl(tstr,'m-3');
  if (tdbl>0)
    dopants(l) = tmp(k);
    Stack.Chan.impurities{l} = struct;
    Stack.Chan.impurities{l}.type = toupper(substr(tmp{k},1,1));
    Stack.Chan.impurities{l}.concentration = tdbl;
    [tstr,err] = rpLibGetString(lib,strcat(pth,'boolean(ideal).current'));
    if (strcmp(tstr,'no'))
      [tstr,err] = rpLibGetString(lib,strcat(pth,'number(energy).current'));
      [Stack.Chan.impurities{l}.energy,err] = rpUnitsConvertDbl(tstr,'meV');
    endif
    l=l+1;
  endif
endfor

% Dielectric
[tstr,err] = rpLibGetString(lib,...
                            'input.group(insulator).number(thickness).current');
[Stack.dielectric{1}.thickness,err] = rpUnitsConvertDbl(tstr,'m');

[Stack.dielectric{1}.kappa,err] = rpLibGetDouble(lib,...
                            'input.group(insulator).number(kappa).current');

% Sim Parameters
psisRng = zeros(1,2);
approx = zeros(3,2);

[tstr,err] = rpLibGetString(lib,'input.number(temperature).current');
[T,err] = rpUnitsConvertDbl(tstr,'K');
[err] = rpLibPutString(lib,'output.log',sprintf('\nT: %g\n',T),1);

tmp = {{'conduction','gamma','lambda','chi'},...
       {'valance','hh','lh','so'}};
for k=1:length(tmp)
  [tstr,err] = rpLibGetString(lib,strcat('input.group(sim_range).number(',...
                                         tmp{k}{1},').current'));
  [psisRng(k),err] = rpUnitsConvertDbl(tstr,'eV');
  [err] = rpLibPutString(lib,'output.log',...
                      sprintf(strcat('\nRng ',tmp{k}{1},': %g'),psisRng(k)),1);
  pth = strcat('input.group(dos).group(',tmp{k}{1},').choice(');
  for l=2:length(tmp{k})
    [approx(l-1,k),err] = rpLibGetDouble(lib,strcat(pth,tmp{k}{l},').current'));
    [err] = rpLibPutString(lib,'output.log',...
                        sprintf(strcat('\n',tmp{k}{l},': %g'),approx(l-1,k)),1);
  endfor
endfor
psisRng = flipdim(psisRng,2);

[N,err] = rpLibGetDouble(lib,'input.group(sim_range).integer(nsteps).current');
[err] = rpLibPutString(lib,'output.log',sprintf('\nN: %u\n',N),1);

[err] = rpLibPutString(lib,'output.log',savejson('',Stack),1);

% Run Simulation
Sim = simMOSCAP(Stack,T,Props,PC,psisRng,N,approx(:,1),approx(:,2));

Cap = sepCap(Sim.psis,Sim.Qc,Sim.n,Sim.p,Sim.NI,Sim.kappas,PC);

[err] = rpLibPutString(lib,'output.log',sprintf('\nmh: %g',Sim.mh./PC.me),1);
[err] = rpLibPutString(lib,'output.log',sprintf('\ndeltaso: %g',Sim.delta_so./PC.e),1);
[err] = rpLibPutString(lib,'output.log',sprintf('\npFB: %g',Cap.pFB.*1e-6),1);
[err] = rpLibPutString(lib,'output.log',sprintf('\nnFB: %g',Cap.nFB.*1e-6),1);
tmp = find(Sim.psis>-0.05);
[err] = rpLibPutString(lib,'output.log',sprintf('\nPOSso: %u',sum(1.*(Cap.Cch(tmp,3)>0))),1);

% Output

% Cgb vs. psis
tmp = [Sim.psis';1e2.*(Sim.Cgb')];
[err] = rpLibPutString(lib,...
                       'output.curve(cgb_psis).component.xy',...
                       sprintf('%12g %12g\n',tmp),0);

% Cgb vs. VGB
tmp = [Sim.VGB';1e2.*(Sim.Cgb')];
[err] = rpLibPutString(lib,...
                       'output.curve(cgb_vgb).component.xy',...
                       sprintf('%12g %12g\n',tmp),0);

% Cc vs. psis
tmp = [Sim.psis';1e-4.*(Sim.Cc')];
[err] = rpLibPutString(lib,...
                       'output.curve(cc_psis).component.xy',...
                       sprintf('%12g %12g\n',tmp),0);

% Rho components vs psi

% rho
tmp = [Sim.psis';1e-6.*(abs(Sim.rho)')./PC.e];
[err] = rpLibPutString(lib,...
                       'output.curve(rho_psi_rho).component.xy',...
                       sprintf('%12g %12g\n',tmp),0);

% Dopants
for k=1:length(dopants)
  tmp = [Sim.psis';1e-6.*(abs(Sim.NI(:,k))')];
  [err] = rpLibPutString(lib,...
                         strcat('output.curve(rho_psi_', ...
                                dopants{k},...
                                ').component.xy'),...
                         sprintf('%12g %12g\n',tmp),0);
endfor

% electrons
tmp = [Sim.psis';1e-6.*(abs(Sim.n(:,1))')];
[err] = rpLibPutString(lib,...
                       'output.curve(rho_psi_gamma).component.xy',...
                       sprintf('%12g %12g\n',tmp),0);

tmp = [Sim.psis';1e-6.*(abs(Sim.n(:,2))')];
[err] = rpLibPutString(lib,...
                       'output.curve(rho_psi_lambda).component.xy',...
                       sprintf('%12g %12g\n',tmp),0);

tmp = [Sim.psis';1e-6.*(abs(Sim.n(:,3))')];
[err] = rpLibPutString(lib,...
                       'output.curve(rho_psi_chi).component.xy',...
                       sprintf('%12g %12g\n',tmp),0);

% holes
tmp = [Sim.psis';1e-6.*(abs(Sim.p(:,1))')];
[err] = rpLibPutString(lib,...
                       'output.curve(rho_psi_hh).component.xy',...
                       sprintf('%12g %12g\n',tmp),0);

tmp = [Sim.psis';1e-6.*(abs(Sim.p(:,2))')];
[err] = rpLibPutString(lib,...
                       'output.curve(rho_psi_lh).component.xy',...
                       sprintf('%12g %12g\n',tmp),0);

tmp = [Sim.psis';1e-6.*(abs(Sim.p(:,3))')];
[err] = rpLibPutString(lib,...
                       'output.curve(rho_psi_so).component.xy',...
                       sprintf('%12g %12g\n',tmp),0);

% Cc components vs psis

% Cc
tmp = [Sim.psis';1e2.*(Sim.Cc')];
[err] = rpLibPutString(lib,...
                       'output.curve(ccomp_psis_cc).component.xy',...
                       sprintf('%12g %12g\n',tmp),0);

% Dopants
for k=1:length(dopants)
  tmp = [Sim.psis';1e2.*(Cap.CcI(:,k)')];
  [err] = rpLibPutString(lib,...
                         strcat('output.curve(ccomp_psis_', ...
                                dopants{k},...
                                ').component.xy'),...
                         sprintf('%12g %12g\n',tmp),0);
endfor

% electrons
tmp = [Sim.psis';1e2.*(Cap.Cce(:,1)')];
[err] = rpLibPutString(lib,...
                       'output.curve(ccomp_psis_gamma).component.xy',...
                       sprintf('%12g %12g\n',tmp),0);

tmp = [Sim.psis';1e2.*(Cap.Cce(:,2)')];
[err] = rpLibPutString(lib,...
                       'output.curve(ccomp_psis_lambda).component.xy',...
                       sprintf('%12g %12g\n',tmp),0);

tmp = [Sim.psis';1e2.*(Cap.Cce(:,3)')];
[err] = rpLibPutString(lib,...
                       'output.curve(ccomp_psis_chi).component.xy',...
                       sprintf('%12g %12g\n',tmp),0);

% holes
tmp = [Sim.psis';1e2.*(Cap.Cch(:,1)')];
[err] = rpLibPutString(lib,...
                       'output.curve(ccomp_psis_hh).component.xy',...
                       sprintf('%12g %12g\n',tmp),0);

tmp = [Sim.psis';1e2.*(Cap.Cch(:,2)')];
[err] = rpLibPutString(lib,...
                       'output.curve(ccomp_psis_lh).component.xy',...
                       sprintf('%12g %12g\n',tmp),0);

tmp = [Sim.psis';1e2.*(Cap.Cch(:,3)')];
[err] = rpLibPutString(lib,...
                       'output.curve(ccomp_psis_so).component.xy',...
                       sprintf('%12g %12g\n',tmp),0);


rpLibResult(lib);
quit;
