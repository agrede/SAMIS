function [Cit,Qit] = citQit(eta, DitD, DitA, T, PC)
  Qit = zeros(length(eta),3);
  Cit = Qit;
  for k = 1:length(eta);
    etaF = eta(k);
    Qit(k,2) = PC.e.*PC.kB.*T.*trapz(DitA.*1./(1+4.*exp(eta-etaF)),eta);
    Qit(k,3) = -PC.e.*PC.kB.*T.*trapz(DitD.*(1./(1+2.*exp(etaF-eta))),eta);
  endfor
  Qit(:,1) = sum(Qit(:,[2 3]),2);
  for k=1:3
    QitPP = interp1(eta.*PC.kB.*T./PC.e,Qit(:,k),'spline','pp');
    Cit(:,k) = -dydx(eta.*PC.kB.*T./PC.e,QitPP,1);
  endfor
endfunction
