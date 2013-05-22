function r = analysisLoadPaths()
% ANALYSISLOADPATHS Add paths used for this program.
%   Returns result of ADDPATH
%
%   See also ADDPATH

selfPath = file_in_loadpath("analysisLoadPaths.m");
selfPath = strtrunc(selfPath,rindex(selfPath,"/"));


paths = {"analysis/","calibrationData/","constants/","fileIO/",...
         "fileIO/jsonlab/","generalFunctions/","generalPlotting/",...
         "materialStacks/","simulation/"};
for k=1:length(paths)
  addpath(strcat(selfPath,paths{k}));
end
r = paths();
endfunction
