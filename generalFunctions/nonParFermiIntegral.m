function [q, err]  = nonParFermiIntegral(alpha,eta,deleta,tol)
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
%       TOL   : [absolute tolerance, relative tolerance] (default=[1e-10,1e-5])
%       
%   See also QUADGK
if (nargin < 3)
  deleta = 0;
endif
if (nargin < 4)
  tol = [1e-10,1e-5];
endif

f    = @(x,eta) (sqrt(x.*(alpha.*x+1)).*(2.*alpha.*x+1))./(1+exp(x-eta-deleta));
leta = length(eta);
q    = zeros(leta,1);
err  = zeros(leta,1);
for n=1:leta
  [q(n),err(n)] = quadgk(@(x) f(x,eta(n)),0,Inf,"AbsTol",tol(1),"RelTol",tol(2));
endfor
q   = q.*2./sqrt(pi);
err = err.*2./sqrt(pi);

endfunction
