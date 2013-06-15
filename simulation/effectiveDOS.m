function N = effectiveDOS(meff,T,PC)
% EFFECTIVEDOS calculates the effective density of states
%   N = EFFECTIVEDOS(MEFF,T,PC)
%       MEFF    effective mass [kg]
%       T       temperature [K]
%       PC      physical constants
%
% Copywrite (C) 2013 Alex J. Grede
% GPL v3, See LICENSE.txt for details
% This function is part of SAMIS (https://github.com/agrede/SAMIS)

N = 2*((2.*pi.*meff.*PC.kB.*T)./(PC.h.^2)).^(3./2);
endfunction
