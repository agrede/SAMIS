function [Cgb,VG] = cgbVgb(Sim,Cox,Cit)
%  CGBVGB Calculates Device Capactiance and Voltage
%    [CGB,VG] = CGBVGB(MOS,COX,CIT)
%       SIM     simulation structure with psis and Cc values
%       COX     oxide capacitance density [F/m^2]
%       CIT     inteface trap capacitance density [F/m^2]

  Cgb = (1./Cox+1./(Sim.Cc+Cit)).^(-1);
  VG = -Sim.Qc./Cox+Sim.psis;
endfunction
