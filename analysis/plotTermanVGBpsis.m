function H = plotTermanVGBpsis(Term,Sim)
% PLOTTERMANVGBPSIS plots psis vs VGB for terman and sim
%   H = PLOTTERMANVGBpsis(TERM,SIM) for TERM and SIM structures
%
% See also TERMANMETHOD,SIMMOSCAP
%
% Copyright (C) 2013 Alex J. Grede
% GPL v3, See LICENSE.txt for details
% This function is part of SAMIS (https://github.com/agrede/SAMIS)

  plot(Term.VGB,Term.psis);
  hold on;
  plot(Term.simVGB-Term.VFB,Sim.psis,'k');
  hold off;
  legend({'Terman','Ideal'});

  % Set limits to (sim can have large VGB/psis values)
  xlim([min(Term.VGB) max(Term.VGB)]);
  ylim([0.8.*min(Term.psis) 1.2.*max(Term.psis)]);

  % Labels
  ylabel('Surface Potential [V]');
  xlabel('Applied Bias [V]');
endfunction
