function H = plotCarConc(Sim)
  % PLOTCARCONC
  %   H = PLOTCARCONC(SIM)
  %       SIM     simulation struct
  %
  % See also MOSCAPSIM
  %
  % Copyright (C) 2013 Alex J. Grede
  % GPL v3, See LICENSE.txt for details
  % This function is part of SAMIS (https://github.com/agrede/SAMIS)

  semilogy(Sim.eta,1e-6.*[Sim.n,sum(Sim.n,2),Sim.p,sum(Sim.p,2)]);
  xlabel('E_C-E_F [kBT]');
  ylabel('Carrier Concentration [cm^-3]');
  set(gca,'yscale','log');
  set(gca,'xminortick','on');
  set(gca,'yminortick','on');
endfunction
