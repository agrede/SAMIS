function res = exportAll()
% EXPORTALL exports data from DITA using exportCV funciton
%
%
% Copyright (C) 2013--2014 Alex J. Grede
% GPL v3, See LICENSE.txt for details
% This function is part of SAMIS (https://github.com/agrede/SAMIS)

  path = uigetdir('./','Export to Folder');
  exportCV(path,DITA.Meas,DITA.Sim,DITA.Term,DITA.Nicol,DITA.Cast,...
           DITA.Cox,DITA.corToUse,DITA.refIndex,PC);
endfunction
