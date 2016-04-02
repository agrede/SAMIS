function r = analysisLoadPaths()
% ANALYSISLOADPATHS Add paths used for this program.
%   Returns result of ADDPATH
%
%   See also ADDPATH
%
% Copyright (C) 2013--2016 Alex J. Grede
% GPL v3, See LICENSE.txt for details
% This function is part of SAMIS (https://github.com/agrede/SAMIS)

selfPath = which('analysisLoadPaths.m');
selfPath = strtrunc(selfPath,rindex(selfPath,'/'));


paths = {'analysis/','calibrationData/','constants/','fileIO/',...
         'fileIO/jsonlab/','generalFunctions/','generalPlotting/',...
         'materialStacks/','simulation/'};
for k=1:length(paths)
  addpath(strcat(selfPath,paths{k}));
end
r = paths();
endfunction
