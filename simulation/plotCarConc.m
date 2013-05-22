function H = plotCarConc(Sim)
  % PLOTCARCONC
  %   H = PLOTCARCONC(SIM)
  %       SIM     simulation struct
  %
  % See also MOSCAPSIM

  semilogy(Sim.eta,1e-6.*[Sim.n,sum(Sim.n,2),Sim.p,sum(Sim.p,2)]);
  xlabel("E_C-E_F [kBT]");
  ylabel("Carrier Concentration [cm^-3]");
  set(gca,"yscale","log");
  set(gca,"xminortick","on");
  set(gca,"yminortick","on");
endfunction
