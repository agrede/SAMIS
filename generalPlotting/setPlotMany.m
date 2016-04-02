function A = setPlotMany(S,x,y,xLab,yLab,legendPoints,legendTitles,legendPos,lw)
%
% Copyright (C) 2013--2014 Alex J. Grede
% GPL v3, See LICENSE.txt for details
% This function is part of SAMIS (https://github.com/agrede/SAMIS)
fn = fieldnames(S);
N = size(fn,1);
A = struct;
cols = ceil(sqrt(N));
rows = ceil(N./cols);

if (nargin < 4)
   xLab = x;
endif
if (nargin < 5)
   yLab = y;
endif
tlp = zeros(0,1);
tlt = cell();

set(gca,'LooseInset',get(gca,'TightInset'));

for n=1:N
    X = S.(fn{n}).(x)(:,:,2);
    Y = S.(fn{n}).(y)(:,:,2);
    if (nargin > 5)
       if (size(X,2)<length(legendPoints))
          tlp = 1:size(X,2);
          tlt = legendTitles((length(legendPoints)-size(X,2)+1):end);
       else
         tlp = legendPoints;
         tlt = legendTitles;
       endif
    endif
    subaxis(rows, cols, n, 'Spacing', 0.03, 'Padding', 0.03, 'Margin', 0.03);
    if (nargin < 7)
      plotMany(X,Y,xLab,yLab);
    elseif (nargin < 9)
      plotMany(X,Y,xLab,yLab,tlp,tlt,legendPos);
    else
      plotMany(X,Y,xLab,yLab,tlp,tlt,legendPos,lw);
    endif
    title(strrep(fn{n}, '_', ' '), 'FontSize',18);
endfor
endfunction
