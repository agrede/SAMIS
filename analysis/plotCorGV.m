function H = plotCorGV(Meas,CorG,Ref,corToUse,Sim)
% PLOTCORGV plots either capacitance or conductance
%   H = PLOTCORGV(MEAS,CORG)
%       MEAS    struct array from measured data. if MEAS.A [m^2] is set will be
%                 normalized to area [cm^2]
%       CORG    string 'C' will plot capacitance, 'G' will plot conductance
%   H = PLOTCORGV(MEAS,CORG,REF)
%       REF     reference with load corrections will use capacitance closest to
%                 median capacitance
%   H = PLOTCORGV(MEAS,CORG,REF,CORTOUSE)
%       CORTOUSE        index of load correction to use 0 will use open/short
%   H = PLOTCORGV(MEAS,CORG,REF,CORTOUSE,SIM)
%       SIM     simulation struct. will plot Sim.VGB and sim.CGB in black
%
% See Also PLOTMANY
%
% Copyright (C) 2013 Alex J. Grede
% GPL v3, See LICENSE.txt for details
% This function is part of SAMIS (https://github.com/agrede/SAMIS)

% Determine area and set correct y label
A = 1;
ytxt = 'Capacitance [F]';
if (isfield(Meas,'A'))
   A = Meas.A.*1e4;
   ytxt = 'Capacitance Density [uF/cm^2]';
endif

% Invalid input
if ((strcmp(CorG,'C')+strcmp(CorG,'G'))<1)
  CorG = 'C';
endif


% Determine Y values -----------------------------------------------------------
if (((nargin < 3)+(~isfield(Meas,'Cor')))>1)    % No reference or no corrections
  Y = Meas.(CorG);
elseif (nargin < 4)                             % User supplied reference
  if (size(Meas.Cor.LC.(CorG),3)>0)     % Use Load Corrections
    % Find nearest ref cap (log)
    medC = median(Meas.C(logical(~isnan(Meas.C))));
    [V,k] = min(abs(log(abs(Ref.Cr./medC))));

    Y = Meas.Cor.LC.(CorG)(:,:,k);
    H = k;
  else                                  % Fallback to Open/Short Cor
    Y = Meas.Cor.osc.(CorG);
    H = 0;
  endif
else                                            % User supplied reference to use
  if ((corToUse>0)*(corToUse<=size(Meas.Cor.LC.(CorG),3)))
    Y = Meas.Cor.LC.(CorG)(:,:,corToUse);
  else                                  % Fallback if user invalid
    Y = Meas.Cor.osc.(CorG);
  endif
endif

% Normalize to Area
Y = 1e6.*Y./A;

% Setup Legend -----------------------------------------------------------------
% Determine Legend Location
legLoc = '';
if (strcmp(CorG,'G'))
  [tV,k1] = max(Y,[],1);
  [tV,k2] = max(tV);
  legLoc = 'north';
  if (isfield(Meas,'A'))
    ytxt = 'Conductance Density [S/cm^2]';
  else
    ytxt = 'Conductance [S]';
  end
else
  [tV,k1] = min(Y,[],1);
  [tV,k2] = min(tV);
  legLoc = 'south';
endif
if (Meas.V(k1(k2),1) < median(Meas.V(:,1)))
  legLoc = strcat(legLoc,'east');
else
  legLoc = strcat(legLoc,'west');
endif

% Setup legend points
leg = {sprintf('%1.1e [Hz]',Meas.f(1,1)),sprintf('%1.1e [Hz]',Meas.f(1,end))};

% Plot -------------------------------------------------------------------------
plotMany(Meas.V,Y,'Applied Bias [V]',ytxt,[1 size(Meas.f,2)],leg,legLoc);

if ((nargin > 4)*strcmp(CorG,'C'))
   hold on;
   plot(Sim.VGB,Sim.Cgb.*1e-4.*1e6,'k');
   hold off;
endif

% Set limits -------------------------------------------------------------------
xlim([min(Meas.V(:,1)),max(Meas.V(:,1))]);

endfunction
