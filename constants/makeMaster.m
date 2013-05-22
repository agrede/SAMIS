function M = makeMaster(paths,PC)
% MAKEMASTER makes master material properties struct
%       M = MAKEMASTER(PATHS)
%               PATHS   paths in decending precident for inclusion
%               PC      physical constants
%       
%       Includes preambles of files in preamble.sources
%       Adds timestamp in ISO 8601 in preamble.compiled

Ss = cell(size(paths));
S = struct;

for n=1:length(paths)
  Ss(n) = loadjson(paths{n});
endfor
S = mergeStruct(Ss);
M = consToSI(S,PC);

M.preamble = struct;
M.preamble.sources = cellfun(@(x) x.preamble,Ss,"UniformOutput",false);
M.preamble.compiled = datestr(now,30);

endfunction
