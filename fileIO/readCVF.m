function rtn = readCVF(path,ref)
% READCVF Reads data from Capacitance voltange and frequency sweeps
%   RTN = READCVF(PATH) reads values with no corrections
%   RTN = READCVF(PATH,REF) reads values and applies corrections from ref
%   Mostly a wrapper for readCVF.pl
%
% Copyright (C) 2013--2014 Alex J. Grede
% GPL v3, See LICENSE.txt for details
% This function is part of SAMIS (https://github.com/agrede/SAMIS)

  rtn = loadjson(perl(file_in_loadpath('readCVF.pl'),path));

  % Calculate Impedance parameters from measured values
  tmp = findImpParams(rtn.Model,rtn.f,rtn.A,rtn.B);
  rtn.C = tmp.C;
  rtn.G = tmp.G;
  rtn.Z = tmp.Z;
  rtn.Y = tmp.Y;

  % Apply corrections if ref specified
  if (nargin > 1)
    rtn.Cor.LC = measCorrection(ref.LC,ref.Zom,ref.Zsm,rtn);
    rtn.Cor.osc = measCorrection(ref.Zom,ref.Zom,ref.Zsm,rtn);
  endif

endfunction
