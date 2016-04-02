function LC = loadCorr(Zom,Zsm,Zrm,Zr)
% LOADCORR calculates the load correction
%   LC = LOADCORR(ZOM,ZSM,ZRM,ZR)
%       ZOM     open circuit measured impedance
%       ZSM     short circuit measured impedance
%       ZRM     reference load measured impedance
%       ZR      reference load known impedance
%
% Copyright (C) 2013--2016 Alex J. Grede
% GPL v3, See LICENSE.txt for details
% This function is part of SAMIS (https://github.com/agrede/SAMIS)

o1 = ones(1,size(Zrm,1));

LC = (Zrm-Zom(o1,:))./(Zsm(o1,:)-Zrm).*Zr;

endfunction
