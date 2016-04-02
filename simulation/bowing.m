function AB = bowing(A,B,C,wts)
%
% Copyright (C) 2013--2016 Alex J. Grede
% GPL v3, See LICENSE.txt for details
% This function is part of SAMIS (https://github.com/agrede/SAMIS)

if (length(wts) == 1)
   wts = [1-wts;wts];
endif
AB = A.*wts(1)+B.*wts(2)-prod(wts([1 2])).*C;

endfunction
