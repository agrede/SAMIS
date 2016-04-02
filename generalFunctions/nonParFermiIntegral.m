function [q, err]  = nonParFermiIntegral(alpha,eta,deleta,tol,quadMode)
% NONPARFERMIINTEGRAL: Computes the integral for carrier concentration with a
%         non-parabolic valley.
%         Integrand: (sqrt(xi*(*xi+1))*(2*ALPHA*xi+1)*dxi)/(1+exp(xi-ETA-DELETA))
%         Limits: xi=0 to Inf
%
%   [Q,ERR] = NONPARFERMIINTEGRAL(ALPHA,ETA)
%       ALPHA   non-parabolic parameter (kT/Eg*(1-m*/me)^2)
%       ETA     relative energy with 0 being at the band edge
%   [Q,ERR] = NONPARFERMIINTEGRAL(ALPHA,ETA,DELETA)
%       DELETA  difference in valley edge from the cond band edge (default=0)
%   [Q,ERR] = NONPARFERMIINTEGRAL(ALPHA,ETA,DELETA,TOL)
%       TOL     [absolute tolerance, relative tolerance] (default=[0,sqrt(eps)])
%   [Q,ERR] = NONPARFERMIINTEGRAL(ALPHA,ETA,DELETA,TOL,QUADMODE)
%       QUADMODE      1: quadgk 2: quadgk->quad 3: quad
%   See also QUADGK,QUAD
%
% Copyright (C) 2013--2016 Alex J. Grede
% GPL v3, See LICENSE.txt for details
% This function is part of SAMIS (https://github.com/agrede/SAMIS)

if (nargin < 3)
  deleta = 0;
endif
if (nargin < 4)
  tol = [0,sqrt(eps)];
endif

if (nargin < 5)
  quadMode = 2;
endif

% Make eta go from low to high for proper mode switch
flipEta = 0;
if (eta(1) > eta(end))
  filpEta = 1;
  eta = flipdim(eta,1);
endif

f    = @(x,eta) (sqrt(x.*(alpha.*x+1)).*(2.*alpha.*x+1))./(1+exp(x-eta-deleta));
leta = length(eta);
q    = zeros(leta,1);
err  = zeros(leta,1);

for n=1:leta
  if (quadMode == 3) % QUAD, slower, more accurate at high eta
    [q(n),tmp1,tmp2,err(n)] = quad(@(x) f(x,eta(n)),0,Inf,tol);
  else % QUADGK faster
    [q(n),err(n)] = quadgk(@(x) f(x,eta(n)),0,Inf,'AbsTol',tol(1),'RelTol',tol(2));
    if ((err(n)/q(n)>tol(2))*(quadMode==2))
      quadMode = 3;
      [q(n),tmp1,tmp2,err(n)] = quad(@(x) f(x,eta(n)),0,Inf,tol); % Rework last
    endif
  endif
endfor

q   = q.*2./sqrt(pi);
err = err.*2./sqrt(pi);

% Flip results back
if (flipEta)
  q = flipdim(q,1);
  err = flipdim(err,1);
endif

endfunction
