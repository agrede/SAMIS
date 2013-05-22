function N = effectiveDOS(meff,T,PC)
% EFFECTIVEDOS calculates the effective density of states
%   N = EFFECTIVEDOS(MEFF,T,PC)
%       MEFF    effective mass [kg]
%       T       temperature [K]
%       PC      physical constants

N = 2*((2.*pi.*meff.*PC.kB.*T)./(PC.h.^2)).^(3./2);
endfunction
