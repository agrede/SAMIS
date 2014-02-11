function [y,ind] = yByEta(psis,Qc,kappa,PC)
% YBYETA calculates y positions for different potentials
%
% [Y,IND] = YBYETA(PSIS,QC,KAPPA,PC)
%       PSIS    = surface potential
%       QC      = channel charge density
%       KAPPA   = semiconductor relitive dielectric constant
%       PC      = physical constants
% Outputs:
%       Y       = postion for each psis condition and psi value
%       IND     = logical matrix of valid points
%
% Copyright (C) 2013 Alex J. Grede
% GPL v3, See LICENSE.txt for details
% This function is part of SAMIS (https://github.com/agrede/SAMIS)

% Initialize
y = zeros(length(psis),length(psis));
ind0 = [0 0]; % Index of psis=0

if (~isempty(find(psis==0)))
  ind0 = find(psis==0,1).*[1 1];
else
  ind0 = find(psis>0,1).*[1 1]-[1 -1];
endif

% Calculate y-ybulk for all psis values
dely = cumtrapz(psis,-PC.epsilon0.*kappa./Qc);


idx = (1:length(dely))'*ones(1,length(dely)); % matrix of 1:length(dely) rows

% Find valid range
ind = ((idx'>=idx).*(idx'<=ind0(1)))+((idx'<=idx).*(idx'>=ind0(2)));

% Subtract dely for psi=psis to find y
y = dely(:,ones(1,length(dely)))-dely(:,ones(1,length(dely)))';

% Set all invalid y values to nan
y(logical(~ind)) = nan;

endfunction
