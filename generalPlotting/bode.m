function res = bode(f,Z,lab,rows,cols,pos)
% BODE makes a loglog magnitude and semilogx angle plot for Z
%   RES = BODE(F,Z)
%       F       frequency (vector is best)
%       Z       complex number (impedance), if F is vector will do a complex
%                 safe transform to orient Z correctly (for 2D matrix)
%   RES = BODE(F,Z,LAB)
%       LAB     cell array containing {variable, mag unit}
%   RES = BODE(F,Z,LAB,ROWS,COLS,POS)
%       ROWS    number of rows in subplot
%       COLS    number of cols in subplot
%       POS     vector containing position of [mag,angle]
%       
% See Also LOGLOG, SEMILOGX, SUBPLOT
%
% Copywrite (C) 2013 Alex J. Grede
% GPL v3, See LICENSE.txt for details
% This function is part of SAMIS (https://github.com/agrede/SAMIS)

% Rearange Z complex safe manner
if (prod(size(f))==max(size(f))) % Only works if f is a vector
   if (size(Z,2)==length(f)) % wrong orientation
      Z = permute(Z,[2,1]);
   endif
endif

% Default labels
if (nargin < 3)
   lab = {'Z','Ohms'};
endif

% Default plot behavior
if (nargin < 4)
   rows = 2;
   cols = 1;
   pos = [1 2];
endif

% Magnitude plot ---------------------------------------------------------------
subplot(rows,cols,pos(1))
if (size(Z,2)>5) % Use jet for more than 5 lines
  set(gca,'ColorOrder',flipdim(jet(size(Z,2)),1));
endif

loglog(f,abs(Z));

ylabel(strcat('|', lab{1},'| [', lab{2}, ']'));

% Angle plot -------------------------------------------------------------------
subplot(rows,cols,pos(2))
if (size(Z,2)>5) % Use jet for more than 5 lines
  set(gca,'ColorOrder',flipdim(jet(size(Z,2)),1));
endif

semilogx(f,angle(Z).*180./pi);

ylabel(strcat('angle(', lab{1}, ') [deg]'));
xlabel('Frequency [Hz]')

endfunction
