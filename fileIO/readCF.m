function rtn = readCF(path)
% READCF Reads CF measurement data in XLS format
%   Wrapper for readCF.pl
%   Returns struct from JSON format returned by readCF.pl for given path
%   

  rtn = loadjson(perl(file_in_loadpath("readCF.pl"),path));

  % Calculate Impedance paramters given the model (Rs/Cs or Gp/Cp)
  tmp = findImpParams(rtn.Model,rtn.f,rtn.A,rtn.B);

  rtn.G = tmp.G;
  rtn.C = tmp.C;
  rtn.Z = tmp.Z;
  rtn.Y = tmp.Y;

endfunction
