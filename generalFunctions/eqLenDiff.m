function dA = eqLenDiff(A)
% EQLENDIFF returns a difference with the same length as the input
%       last value is approximated using a second diff
%   DA = EQLENDIFF(A)
%       A       row vector
%       
%       DA      result row vector

dA = diff(A,[],2);

% dA[N] = dA[N-1] + (dA[N-1] - dA[N-2])
dA = [dA,2.*dA(:,end)-dA(:,end-1)];


endfunction
