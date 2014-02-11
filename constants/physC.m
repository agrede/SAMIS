function C = physC()
% PHYSC structure with physical constants in SI units
%   Constants from NIST.gov Accessed: 2013-03-09 (2010 values)
%   Uncertianty values in Uncertainty sub structure
%
% Copyright (C) 2013--2014 Alex J. Grede
% GPL v3, See LICENSE.txt for details
% This function is part of SAMIS (https://github.com/agrede/SAMIS)

  C = struct;
  C.Uncertainty = struct;

  % Plank Constant J*s
  C.h = 6.62606957e-34;
  C.Uncertainty.h = 0.00000029e-34;
  C.hbar = 1.054571726e-34;
  C.Uncertainty.hbar = 0.000000047e-34;

  % Speed of light [m/s]
  C.c0 = 299792458;
  C.Uncertainty.c0 = 0;

  % Magnetic Constant [N/A^2]
  C.mu0 = 4e-7*pi;
  C.Uncertainty.mu0 = 0;

  % Electric Constant [F/m]
  C.epsilon0 = 1./(C.mu0(1).*(C.c0(1)).^2);
  C.Uncertainty.epsilon0 = 0;

  % Elementary Charge [C]
  C.e = 1.602176565e-19;
  C.Uncertainty.e = 0.000000035e-19;

  % Electron Mass [kg]
  C.me = 9.10938291e-31;
  C.Uncertainty.me = 0.0000004e-31;

  % Boltzmann constant [J/K]
  C.kB = 1.3806488e-23;
  C.Uncertainty.kB = 0.0000013e-23;

endfunction
