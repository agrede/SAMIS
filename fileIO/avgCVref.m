function res = avgCVref(ref)
%
% Copyright (C) 2013 Alex J. Grede
% GPL v3, See LICENSE.txt for details
% This function is part of SAMIS (https://github.com/agrede/SAMIS)

res.C = mean(ref.C,1);
res.G = mean(ref.G,1);

res.f = ref.f;

res.Y = res.G+I.*2.*pi.*res.f.*res.C;
res.Z = 1./res.Y;

endfunction
