function H = plotOpenShortMeas(Ref)
% PLOTOPENSHORTMEAS bode plots for open and short meas
%   H = PLOTOPENSHORTMEAS(REF)
%       REF     structure array of reference CF meas
%
% See also READCORR, BODE


bode(Ref.f(1,:),[Ref.Zom;Ref.Zsm]);
legend({"Open","Short"});

endfunction
