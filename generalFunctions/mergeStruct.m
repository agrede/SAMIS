function S = mergeStruct(Ss)
% MERGESTRUCT  Merges a cell array of structures
%  For fields that exist in more than one structure the first
%  struct takes priority. If the field is a structure. this is merged
%
% See also CAT
%
% Copywrite (C) 2013 Alex J. Grede
% GPL v3, See LICENSE.txt for details
% This function is part of SAMIS (https://github.com/agrede/SAMIS)


S = Ss{1};

for n=2:length(Ss)
  fns = fieldnames(Ss{n});
  for m = 1:length(fns)
    if (~isfield(S,fns{m}))
      S.(fns{m}) = Ss{n}.(fns{m});
    elseif (isstruct(S.(fns{m})))
      S.(fns{m}) = mergeStruct({S.(fns{m}),Ss{n}.(fns{m})});
    endif
  endfor
endfor
endfunction

