function [hhem,lhem] = heffMass(gamma,PC)
% HEFFMASS estimates DOS effective mass from Luttinger parameters
%       [HHEM,LHEM] = HEFFMASS(GAMMA,PC)
%               GAMMA   Luttinger parameter vector [gamma1;gamma2;gamma3]
%               PC      physical constants
%       Note: this is known to be wrong. but is close enough for a rough backup
%             can be improved in future for accurate results
%
% Copywrite (C) 2013 Alex J. Grede
% GPL v3, See LICENSE.txt for details
% This function is part of SAMIS (https://github.com/agrede/SAMIS)

HH = [1 -2 0;1 -0.5 -1.5;1 0 -2];
LH = [1 2 0;1 0.5 1.5;1 0 2];
S = [1 0 0;0 1 0; 0 1 0];

hhem = PC.me.*(prod(S*(1./(HH*gamma)))).^(1./3);
lhem = PC.me.*(prod(S*(1./(LH*gamma)))).^(1./3);

endfunction
