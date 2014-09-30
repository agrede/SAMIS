function Mos = simMOSCAP(Stack,T,Param,PC,psisRng,neta,approxC,approxV)
% SIMMOSCAP simulates moscap by solving the carrier concentrations and
%   poisson equation
%
%   MOS = SIMMOSCAP(STACK,T,PROP,PC)
%       STACK   = gate stack struct (must use SI units)
%       T       = temperature in K
%       PROP    = material property parameters (band params, dielectrics, etc.)
%       PC      = physical constants (epsilon0, boltzmann constant, etc.)
%   MOS = SIMMOSCAP(STACK,T,PROP,PC,PSISRNG)
%       PSISRNG = range of simulaiton in eV [|below val band|,|above cond band|]
%                       (default [0.5 0.5])
%   MOS = SIMMOSCAP(STACK,T,PROP,PC,PSISRNG,NETA)
%       NETA    = number of points across range to calculate (default 5001)
%   MOS = SIMMOSCAP(STACK,T,PROP,PC,PSISRNG,NETA,APPROXC,APPROXV)
%       APPROXC = approximations to use for [Gamma;X;L] valley in electron conc
%                       (default [3;2;2])
%       APPROXV = approximations to use for [hh;lh;so] in hole conc
%                       (default [2;2;2])
%       Approximations: (Note: some settings could give wildly inaccurate values)
%               0: Ignore this component
%               1: Maxwell-Boltzmann with parabolic band
%               2: Fermi-Dirac with parabolic band
%               3: Fermi-Dirac with non-parabolic band
%
%   MOS has these fields:
%       Cox     oxide capacitance density used [F/m^2]
%       me      effective mass of [Gamma;X;L] valleys [kg]
%       mh      effective mass of [hh;lh;so] [kg]
%       Eg      energy gap of [Gamma;X;L] [J]
%       delta_so spin off band energy difference [J]
%       kappas  dielectric constant of semiconductor
%       eta     difference in energy between fermi and cond band norml to kBT
%       n       electron concentration by eta for [Gamma,X,L] valleys [m^-3]
%       p       hole concentration by eta for [hh,lh,so] [m^-3]
%       rho     charge density (SUM(p,2)-SUM(n,2)+N_D-N_A) by eta [C/m^3]
%       Qc      charge in channel by psis [C/m^2]
%       Cc      small-signal capacitance denisty  of channel by psis [F/m^2]
%       psis    surface potential [V]
%       Cgb     small-signal capacitance density of ideal device [F/m^2] by psis
%       VGB     potential bias accross device [V] by psis
%
% Copyright (C) 2013--2014 Alex J. Grede
% GPL v3, See LICENSE.txt for details
% This function is part of SAMIS (https://github.com/agrede/SAMIS)

if (nargin < 6)
  psisRng = [0.5 0.5];
endif
if (nargin < 7)
  neta = 5001;
endif
if (nargin < 8)
  approxC = [3;2;2];
  approxV = [2;2;2];
endif

Mos = semiProps(Stack.Chan,T,Param,PC);

Mos.Cox = cox(Stack,Param,PC);

kT = PC.kB.*T; % Usefull shorthand

Mos.etaV = -min(Mos.Eg)./kT;
Mos.eta = linspace(-(psisRng(1).*PC.e+min(Mos.Eg)),psisRng(2).*PC.e,neta)'./kT;
Mos.NI = impurities(Mos.eta,Mos.etaV,Stack.Chan.impurities,T,Mos.Impurities,PC);
Mos.n = carConc(Mos.eta,Mos.me,(min(Mos.Eg)-Mos.Eg)./kT,Mos.Eg,approxC,T,PC);
Mos.p = carConc(-Mos.eta,Mos.mh,([0;0;-Mos.delta_so]-min(Mos.Eg))./kT,...
                 ([0;0;Mos.delta_so]+min(Mos.Eg)),approxV,T,PC);
Mos.rho = PC.e.*sum([Mos.p -Mos.n Mos.NI],2);
[Mos.Qc,Mos.Cc,Mos.psis] = poissonSolution(Mos.eta,Mos.rho,T,Mos.kappas,PC);
[Mos.Cgb,Mos.VGB] = cgbVgb(Mos,Mos.Cox,0);

endfunction
