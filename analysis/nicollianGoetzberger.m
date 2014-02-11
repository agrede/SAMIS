function Res = nicollianGoetzberger(V,Cm,Gm,f,Cox,PC)
% NICOLLIANCOETZBERGER finds the interface traps via conductance method
%   RES = NICOLLIANGOETZBERGER(V,CM,GM,F,COX,PC)
%       V       applied bias
%       CM      measured capacitance density
%       GM      measured conductance density
%       F       frequency of measurments
%       COX     oxide capacitance density
%       PC      physical constants
%
% Copyright (C) 2013 Alex J. Grede
% GPL v3, See LICENSE.txt for details
% This function is part of SAMIS (https://github.com/agrede/SAMIS)

  omega = 2.*pi.*f(ones(1,size(Cm,1)),:);

  % Gp/omega
  Res.Gpomega = omega.*Gm.*Cox.^2./(Gm.^2+omega.^2.*(Cox-Cm).^2);

  % Find max values and locations
  [tmp,k] = max(Res.Gpomega,[],2);
  Res.Dit = 2.5./(PC.e).^2.*tmp;
  Res.Cit = (PC.e).^2.*Res.Dit;
  Res.f = f(k);

endfunction
