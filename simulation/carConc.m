function n = carConc(eta,meff,deleta,Eg,modl,T,PC)
% CARCONC calculates the carrier concentration
%   N = CARCONC(ETA,MEFF,DELETA,EG,MODL,T,PC)
%       ETA     Fermi level diff to cond band edge (k x 1 vector)
%                 (specify -ETA for holes)
%       MEFF    DOS Effective mass (m x 1 vector)
%       DELETA  Difference from valley to conduction band edge (m x 1 vector)
%                 (specify (E_V-E_C)/kT for holes)
%       EG      energy gap difference for non-parabolic calculations (m x 1)
%       MODL    Model or assumptions to make (m x 1 vector)
%                 0     Zeros for all of ETA
%                 1     Maxwell-Boltzmann stats and Parabolic DOS
%                 2     Fermi-Dirac stats and Parabolic DOS
%                 3     Fermi-Dirac stats and Non-Parabolic DOS
%                 -     Same as 0
%       T       temperature
%       PC      physical constants
%
%       N       Carrier concentration result (k x m matrix)
%
% Copyright (C) 2013 Alex J. Grede
% GPL v3, See LICENSE.txt for details
% This function is part of SAMIS (https://github.com/agrede/SAMIS)

n = zeros(length(eta),length(meff));

N = effectiveDOS(meff,T,PC);

modl(logical(isnan(meff))) = 0;         % effmass of NaN gives all 0s
modl(logical(meff==0)) = 0;             % effmass of  0 gives all 0s
modl(logical(isinf(deleta))) = 0;       % deleta of InF gives all 0s

% Non-zero only for those using the non-parabolic model
alpha = (modl==3).*PC.kB.*T./Eg.*(1-meff./PC.me).^2;

for j=1:length(meff)
    if (modl(j) == 1) % Boltzmann
      n(:,j) = N(j).*exp(eta+deleta(j));
    elseif (modl(j) == 2)
      [tmp,err] = fermi_dirac_half(eta+deleta(j));
      n(:,j) = N(j).*tmp;
    elseif (modl(j) == 3) % Fermi-Dirac Statistics
      [tmp,err] = nonParFermiIntegral(alpha(j),eta,deleta(j),[0,sqrt(eps)],2);
      n(:,j) = N(j).*tmp;
    endif
endfor

endfunction
