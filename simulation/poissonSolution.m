function [Qc,Cc,psis] = poissonSolution(eta,rho,T,kappas,PC)
% POISSONSOLUTION Solves the 1-D Poisson equation for a MOSCAP
%   [QC,CC,PSIS] = POISSONSOLUTION(ETA,RHO,T,KAPPA,PC)
%       ETA     vector of (E_C-E_F)/kT
%       RHO     charge density by ETA
%       T       temperature
%       KAPPAS  substrate dielectric constant
%       PC      physical constants
%
%       QC      charge density of substrate by surface potential
%       CC      small-signal capacitance density of substrate by surface potential
%       PSIS    surface potential

psi = PC.kB.*T./PC.e.*eta;          % q(E_C-E_F)
psi0 = interp1(rho,psi,0,'spline'); % \psi in the bulk (\rho(\psi) = 0)
psis = psi-psi0;                    % surface potential

% f [n] = \int_{\psi [1]}^{\psi [n]} \rho(\psi) d \psi
f = cumtrapz(psi,rho);
% \int_{\psi [1]}^{\psi_{bulk}} \rho(\psi) d\psi
F = interp1(psi,f,psi0,'spline');

% Q_c [n] = -\sign(\psi_s)
%       \sqrt{-2\kappa_s\epsilon_0 \int_{\psi_{bulk}}^{\psi_s} \rho(\psi) d\psi}
% (or)
% Q_c [n] = -\sign(\psi_s) \sqrt{C f [n] - F}
%       C = -2\kappa_s\epsilon_0
Qc = -sign(psis).*sqrt(-2.*PC.epsilon0.*kappas.*(f-F));

% C_c (\psis) = \frac{d Q_c}{d \psi_s}
% C_c [n] \approx \frac{Q_c [n] - Q_c [n-1]}{\psis [n] - \psis [n-1]}
Cc = -(eqLenDiff(Qc')./eqLenDiff(psis'))';

endfunction
