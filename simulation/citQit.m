function [Cit,Qit] = citQit(eta, DitD, DitA, T, PC)
  % CITQIT calculates Cit and Qit for different interface state densities
  %   and types.
  %
  % [CIT,QIT] = CITQIT(ETA,DITD,DITA,T,PC)
  %     ETA     = relative energy
  %     DITD    = donor type interface state density by eta
  %     DITA    = acceptor type interface state density by eta
  %     T       = temperature
  %     PC      = physical constants
  %
  % Outputs:
  %     CIT     = interface state capacitance by eta
  %     Qit     = interface state charge by eta
  %     Each has 3 columns:
  %       1: Total
  %       2: Acceptor
  %       3: Donor
  %
  % Copyright (C) 2013 Alex J. Grede
  % GPL v3, See LICENSE.txt for details
  % This function is part of SAMIS (https://github.com/agrede/SAMIS)

  % Init
  Qit = zeros(length(eta),3);
  Cit = Qit;

  % Calculate charge densities
  for k = 1:length(eta);
    etaF = eta(k);
    Qit(k,2) = PC.e.*PC.kB.*T.*trapz(DitA.*1./(1+4.*exp(eta-etaF)),eta);
    Qit(k,3) = -PC.e.*PC.kB.*T.*trapz(DitD.*(1./(1+2.*exp(etaF-eta))),eta);
  endfor
  Qit(:,1) = sum(Qit(:,[2 3]),2); % Total

  % Calculate capacitance (uses cubic spline to determine derivitive)
  for k=1:3
    QitPP = interp1(eta.*PC.kB.*T./PC.e,Qit(:,k),'spline','pp');
    Cit(:,k) = -dydx(eta.*PC.kB.*T./PC.e,QitPP,1);
  endfor
endfunction
