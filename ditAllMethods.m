%
% Copyright (C) 2013--2014 Alex J. Grede
% GPL v3, See LICENSE.txt for details
% This function is part of SAMIS (https://github.com/agrede/SAMIS)

PC = physC;
DITA = struct;

[tmpName,tmpPath] = uigetfile({'*.json','JSON'},'Reference Calibration File');
DITA.calPath = strcat(tmpPath,tmpName);

DITA.refPath = uigetdir('./','Path to Calibration Measurements');

DITA.Ref = readCorr(DITA.refPath,DITA.calPath);

[tmpName,tmpPath] = uigetfile({'*.xls','XLS'},'Measurment File');
DITA.measPath = strcat(tmpPath,tmpName);

DITA.Meas = readCVF(DITA.measPath,DITA.Ref);

DITA.Meas.A = input('A [cm^2] = ').*1e-4;

DITA.T = input('Temperature [K] = ');

DITA.Vmult = 2.*(yes_or_no('Forward Bias Config?')-0.5);

DITA.Meas.V = DITA.Meas.V.*DITA.Vmult;

DITA.Ref.V = DITA.Meas.V.*DITA.Vmult;

DITA.refIndex = plotCorGV(DITA.Meas,'C',DITA.Ref);
if (DITA.refIndex == 0)
  DITA.refToUse = 'osc';
  DITA.refIndex = 1;
else
  DITA.corToUse = 'LC';
endif

DITA.Cox = input('Cox [F/cm^2] = ').*1e4;

[tmpName,tmpPath] = uigetfile({'*.json','JSON'},'Simulation Stack');
DITA.Stack = loadjson(strcat(tmpPath,tmpName));

DITA.Props = loadjson(file_in_loadpath('master.json'));

DITA.Sim = simMOSCAP(DITA.Stack,DITA.T,DITA.Props,PC);

if (DITA.Cox == 0)
   DITA.Cox = DITA.Sim.Cox;
endif

DITA.Cast = castagneVapaille(DITA.Meas.Cor.(DITA.corToUse).C(:,1,DITA.refIndex),
                             DITA.Meas.Cor.(DITA.corToUse).C(:,end,DITA.refIndex),
                             DITA.Cox,PC);

DITA.Term = termanMethod(DITA.Meas.Cor.(DITA.corToUse).C(:,end,DITA.refIndex),
                         DITA.Meas.V(:,1), DITA.Sim, DITA.Cox, PC);

DITA.Nicol = nicollianGoetzberger(DITA.Meas.V,
                                  DITA.Meas.Cor.(DITA.corToUse).C(:,:,DITA.refIndex),
                                  DITA.Meas.Cor.(DITA.corToUse).G(:,:,DITA.refIndex),
                                  DITA.Meas.f, DITA.Cox, PC);
