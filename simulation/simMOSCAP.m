function Mos = simMOSCAP(Stack,T,Param,PC,psisRng,neta,approxC,approxV)
% SIMMOSCAP simulates moscap by solving the carrier concentrations and
%   poisson distribution
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

Mos = struct;

Mos.Cox = cox(Stack,Param,PC);

kT = PC.kB.*T; % Usefull shorthand


if (length(Stack.Chan.groupB)<1)
% Group IV assumed
elseif (length(Stack.Chan.groupA)+length(Stack.Chan.groupB)<3)
  % Binary Assumed
  mat = strcat(Stack.Chan.groupA,Stack.Chan.groupB);
  A = moscParam(Param.(Stack.Chan.crystalStructure).(mat),T,PC);
  Mos.me = A.me;
  Mos.mh = A.mh;
  Mos.Eg = A.Eg;
  Mos.delta_so = A.delta_so;
  Mos.kappas = A.kappas;
else
  % Combination of ternaries (only can do up to quaternary?)
  [mats, weights] = ternaryPermitations(Stack.Chan.groupA,Stack.Chan.groupB,...
                                        Stack.Chan.weightsA,Stack.Chan.weightsB);
  Mos.mats = mats;
  Mos.weights = weights;
  % Initialize Variables
  Mos.me = [0;0;0];
  Mos.mh = [0;0;0];
  Mos.Eg = [0;0;0];
  Mos.delta_so = 0;
  Mos.kappas = 0;
  
  % Add weighted combinations
  for k=1:size(mats,2)
    A = moscParam(Param.(Stack.Chan.crystalStructure).(mats{1,k}),T,PC);
    B = moscParam(Param.(Stack.Chan.crystalStructure).(mats{2,k}),T,PC);
    C = struct;

    if (isfield(Param.(strcat("Bow_",Stack.Chan.crystalStructure)),mats{3,k}))
      C = Param.(strcat("Bow_",Stack.Chan.crystalStructure)).(mats{3,k});
      C.Eg = C.E_g+weights(2,k).*C.E_g_1;
      C.kappas = C.kappa;
      C.me = [C.meffe;C.meffDOS];
      C.mh = [C.meffhh;C.mefflh;C.meffso];
    else
      C.Eg = 0;
      C.me = 0;
      C.mh = 0;
      C.kappas = 0;
      C.delta_so = 0;
    endif
    Mos.me = Mos.me + weights(3,k).*bowing(A.me,B.me,C.me,weights(:,k));
    Mos.Eg = Mos.Eg + weights(3,k).*bowing(A.Eg,B.Eg,C.Eg,weights(:,k));
    Mos.kappas = Mos.kappas + weights(3,k).*bowing(A.kappas,B.kappas,...
                                                   C.kappas,weights(:,k));
    Mos.mh = Mos.mh +weights(3,k).*bowing(A.mh,B.mh,C.mh,weights(:,k));
    Mos.delta_so = Mos.delta_so +weights(3,k).*bowing(A.delta_so,...
                                                      B.delta_so,...
                                                      C.delta_so,...
                                                      weights(:,k));
  endfor
  % Divide by sum of weights
  Mos.me = Mos.me./sum(weights(3,:));
  Mos.mh = Mos.mh./sum(weights(3,:));
  Mos.Eg = Mos.Eg./sum(weights(3,:));
  Mos.kappas = Mos.kappas./sum(weights(3,:));
  Mos.delta_so = Mos.delta_so./sum(weights(3,:));
endif

Mos.eta = linspace(-(psisRng(1).*PC.e+min(Mos.Eg)),psisRng(2).*PC.e,neta)'./kT;
Mos.n = carConc(Mos.eta,Mos.me,(min(Mos.Eg)-Mos.Eg)./kT,Mos.Eg,approxC,T,PC);
Mos.p = carConc(-Mos.eta,Mos.mh,([0;0;-Mos.delta_so]-min(Mos.Eg))./kT,...
                ([0;0;Mos.delta_so]+min(Mos.Eg)),approxV,T,PC);
Mos.rho = PC.e.*(sum(Mos.p,2)-sum(Mos.n,2)+Stack.Chan.N_D-Stack.Chan.N_A);
[Mos.Qc,Mos.Cc,Mos.psis] = poissonSolution(Mos.eta,Mos.rho,T,Mos.kappas,PC);
[Mos.Cgb,Mos.VGB] = cgbVgb(Mos,Mos.Cox,0);

endfunction
