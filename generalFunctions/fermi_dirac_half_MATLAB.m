function [q, err]  = fermi_dirac_half_MATLAB(eta,tol)
% FERMI_DIRAC_HALF_MATLAB: quick quadgk to find Fermi dirac half integral
%   [Q,ERR] = FERMI_DIRAC_HALF_MATLAB(ETA)
%       ETA     relative energy with 0 being at the band edge
%   [Q,ERR] = FERMI_DIRAC_HALF_MATLAB(ETA,TOL)
%       TOL   : [absolute tolerance, relative tolerance] (default=[1e-10,1e-5])
%
%   See also QUADGK
%
% Copyright (C) 2013--2016 Alex J. Grede
% GPL v3, See LICENSE.txt for details
% This function is part of SAMIS (https://github.com/agrede/SAMIS)

if (nargin < 2)
  tol = [1e-10,1e-5];
endif

f    = @(x,eta) sqrt(x)./(1+exp(x-eta));
leta = length(eta);
q    = zeros(leta,1);
err  = zeros(leta,1);
for n=1:leta
  [q(n),err(n)] = quadgk(@(x) f(x,eta(n)),0,Inf,'AbsTol',tol(1),'RelTol',tol(2));
endfor
q   = q.*2./sqrt(pi);
err = err.*2./sqrt(pi);

endfunction
