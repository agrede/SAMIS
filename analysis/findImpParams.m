function P = findImpParams(model,f,A,B)
% FINDIMPPARAMS
%   P = FINDIMPPARAMS(MODEL,F,A,B)
%       MODEL   determines how A and B are used
%               MODEL   A       B
%               0       Rs      Cs
%               1       Gp      Cp
%               2       Z       -
%               3       Y       -
%       F       frequency row vector or specified for all A
%       A       parameter (see above)
%       B       parameter (see above)
%
%   P = FINDIMPPARAMS(MODEL,F,A)
%       Only for Model 2 or 3
%
% Copyright (C) 2013--2014 Alex J. Grede
% GPL v3, See LICENSE.txt for details
% This function is part of SAMIS (https://github.com/agrede/SAMIS)

if (nargin < 3 && model < 2)
   error('not enough input arguments');
endif

if (size(f,1) ~= size(A,1))
   f = f(ones(1,size(A,1)),:);
endif


P = struct;
if (model == 0)
  P.Z = A - I./(2.*pi.*f.*B);
  P.Y = 1./P.Z;
elseif (model == 1)
  P.Y = A + I.*2.*pi.*f.*B;
  P.Z = 1./P.Y;
elseif (model == 2)
  P.Z = A;
  P.Y = 1./P.Z;
elseif (model == 3)
  P.Y = A;
  P.Z = 1./P.Y;
endif

P.G = real(P.Y);
P.C = imag(P.Y)./(2.*pi.*f);

endfunction
