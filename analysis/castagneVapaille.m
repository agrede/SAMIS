function Res = castagneVapaille(Clf,Chf,Cox,PC)
% CASTAGNEVAPAILLE (Cast-on-ya Vah-pee-eh) AKA high low
%   Res = CASTAGNEVAPAILLE(CLF,CHF,COX,PC)
%       CLF     measured low-frequency cap density
%       CHF     measured high-frequency cap density
%       COX     oxide capacitance density
%       PC      physical constants
%
%
% Copyright (C) 2013 Alex J. Grede
% GPL v3, See LICENSE.txt for details
% This function is part of SAMIS (https://github.com/agrede/SAMIS)

  Res.Cit = Cox.*(Clf./Cox./(1-Clf./Cox)-Chf./Cox./(1-Chf./Cox));
  Res.Dit = Res.Cit./((PC.e).^2);

endfunction
