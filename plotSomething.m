%
% Copyright (C) 2013 Alex J. Grede
% GPL v3, See LICENSE.txt for details
% This function is part of SAMIS (https://github.com/agrede/SAMIS)

X = menu(
        'Select Plot Type:',...         
        'Open / Short Measurement',...  % 1
        'Ref Measurement Accuracy',...  % 2
        'C-V',...                       % 3
        'G-V',...                       % 4
        'Dit',...                       % 5
        'Terman Method psis',...        % 6
        'Conductance Map',...           % 7
        'Carrier Concentration'...      % 8
      );
close all;
switch (X)
  case 1
    plotOpenShortMeas(DITA.Ref);
  case 2
    plotLoadMeas(DITA.Ref);
  case 3
    plotCorGV(DITA.Meas,'C',DITA.Ref);
  case 4
    plotCorGV(DITA.Meas,'G',DITA.Ref);
  case 5
    plotCombinedDit(DITA.Meas.V(:,1),DITA.Term,DITA.Nicol,DITA.Cast,PC);
  case 6
    plotTermanVGBpsis(DITA.Term,DITA.Sim);
  case 7
    plotCondMap(DITA.Meas.V(:,1),DITA.Meas.f(1,:),DITA.Nicol.Gpomega,...
                DITA.Meas.SignalLevel,PC);
  case 8
    plotCarConc(DITA.Sim);
  otherwise
    plot(1:10,1:10); % nothing happens
endswitch
       
