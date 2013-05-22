function Eg = bandGap(E_g0,alpha,beta,T,alphacoth,betacoth)
% BANDGAP calculates the bandgap at temp using Varishni form and others
%   EG = BANDGAP(E_G0,ALPHA,BETA,T)
%       E_G0    energy gap at 0K
%       ALPHA   Varishni parameter [energy/K]
%       BETA    Varishni parameter [K]
%   EG = BANDGAP(E_G0,ALPHA,BETA,T,ALPHACOTH,BETACOTH)
%       ALPHA     should be 0 wherever alphacoth is set
%       ALPHACOTH is for form EG = A*(1-coth(B/T)), 0 when alpha is set
%       BETA      should be 0 whenever alphacoth is set
%       BETACOTH  is for form EG = A*(1-coth(B/T)), 1 when alpha is set

if (nargin < 5)
   alphacoth = zeros(size(E_g0));
   betacoth = ones(size(E_g0));
endif

Eg = E_g0-alpha.*T.^2./(beta+T)+alphacoth.*(1-coth(betacoth./T));

endfunction
