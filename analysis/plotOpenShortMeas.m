function H = plotOpenShortMeas(Ref)
% PLOTOPENSHORTMEAS bode plots for open and short meas
%   H = PLOTOPENSHORTMEAS(REF)
%       REF     structure array of reference CF meas
%
% See also READCORR, BODE
%
% Copyright (C) 2013 Alex J. Grede
% GPL v3, See LICENSE.txt for details
% This function is part of SAMIS (https://github.com/agrede/SAMIS)

bode(Ref.f(1,:),[Ref.Zom;Ref.Zsm]);
legend({'Open','Short'});

endfunction
