function Mos = moscParam(Param,T,PC)
%  MOSCPARAM sets the right parameters needed for MOSCAP calculations
%       MOS = MOSCPARAM(PARAM,T,PC)
%               PARAM   material parameters
%               T       temperature
%               PC      physical constants

Mos = struct;

% Hole DOS effmass [hh;lh;so] --------------------------------------------------
% Backup estimates (function could be fixed to give real values)
[mhhEst,mlhEst] = heffMass(Param.gamma,PC);

Mos.mh = [0;0;0];
if (~isnan(Param.meffhh)) % Prefered HH value
  Mos.mh(1) = Param.meffhh;
else
  Mos.mh(1) = mhhEst;
endif
if (~isnan(Param.mefflh)) % Prefered LH value
  Mos.mh(2) = Param.mefflh;
else
  Mos.mh(2) = mlhEst;
endif
Mos.mh(3) = Param.meffso;

% Electron DOS effmass [Gamma;X;L] ---------------------------------------------
tmpmA = Param.meffDOS; % Perfered number
tmpmB = (Param.meffl.*Param.mefft.^2).^(1./3); % Backup solution

% Uses backup solution numbers for [X;L] DOS effm if perfered is NaN
tmpmA(logical(isnan(tmpmA))) = tmpmB(logical(isnan(tmpmA)));

% Uses meffe if still nan
tmpmA(logical(isnan(tmpmA))) = Param.meffe;

% Combine   
Mos.me = [Param.meffe;tmpmA];

% Additional Params ------------------------------------------------------------
Mos.Eg = bandGap(Param.E_g0, Param.alpha, Param.beta,T,
                 Param.alphacoth, Param.betacoth);

Mos.delta_so = Param.delta_so;

Mos.kappas = Param.kappa;

endfunction
