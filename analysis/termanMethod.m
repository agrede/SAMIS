function Res = termanMethod(Cm,V,Sim,Cox,PC)
% TERMANMETHOD High frequency method that requires ideal model
%   RES = TERMANMETHOD(CM,V,SIM,COX,PC)
%       CM      measured capacitance density
%       V       gate bias
%       SIM     simulation model
%       COX     dielectric capacitance density to use
%       PC      physical constants
%
% Copyright (C) 2013 Alex J. Grede
% GPL v3, See LICENSE.txt for details
% This function is part of SAMIS (https://github.com/agrede/SAMIS)

  % Find Ideal Cgb with specified Cox ------------------------------------------
  [Cgb,VGB] = cgbVgb(Sim,Cox,0);

  % Filter out inversion -------------------------------------------------------
  [tmp,kmin] = min(Cgb);
  kfb = find(Sim.psis>0,1);
  if (kmin < kfb) %NMOS
    Cgb = Cgb(kmin:end);
    psis = Sim.psis(kmin:end);
    Cc = Sim.Cc(kmin:end);
  else %PMOS
    Cgb = Cgb(1:kmin);
    psis = Sim.psis(1:kmin);
    Cc = Sim.Cc(1:kmin);
  endif

  % Interpolate params and find Dit --------------------------------------------
  Res.VGB = V;
  Res.simVGB = VGB;
  Res.psis = interp1(Cgb,psis,Cm,'spline');
  Res.VFB = interp1(Res.psis,V,0,'spline');
  Res.Cc = interp1(psis,Cc,Res.psis,'spline');
  Res.VGBPP = interp1(Res.psis,Res.VGB,'spline','pp');
  Res.dVdpsis = (eqLenDiff(Res.VGB')./eqLenDiff(Res.psis'))';
  %Res.dVdpsis = dydx(Res.psis,Res.VGBPP,1);
  Res.Cit = Cox.*(Res.dVdpsis-1)-Res.Cc;
  Res.Dit = Res.Cit./(PC.e).^2;
endfunction
