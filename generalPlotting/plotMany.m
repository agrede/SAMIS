function A = plotMany(X,Y,xLab,yLab,legendPoints,legendTitles,legendPos,lw)
% PLOTMANY plots multiple lines uses slightly custom jet colormap
%       returns sturct that contains some graphics handles
%   A = PLOTMANY(X,Y)
%       X       n x m matrix of X points (can be n x 1 vector)
%       Y       n x m matrix of Y points (z varible should be increasing in m)
%   A = PLOTMANY(X,Y,XLAB)
%       XLAB    string for xlabel
%   A = PLOTMANY(X,Y,XLAB,YLAB)
%       YLAB    string for ylabel
%   A = PLOTMANY(X,Y,XLAB,YLAB,LEGENDPOINTS,LEGENDTITLES,LEGENDPOS)
%       LEGENDPOINTS    set of positions in n that should contain a legend
%       LEGENDTITLES    corrisponding set of titles to use for legend
%       LEGENDPOS       string specifying legend position (e.g. 'NORTH')
%   A = PLOTMANY(X,Y,XLAB,YLAB,LEGENDPOINTS,LEGENDTITLES,LEGENDPOS,LW)
%       LW      line width 4 is good for export, not for screen
%
%   See also PLOT,XLABEL,YLABEL,LEGEND
%
% Copyright (C) 2013--2016 Alex J. Grede
% GPL v3, See LICENSE.txt for details
% This function is part of SAMIS (https://github.com/agrede/SAMIS)

A = struct;

% Set colors, uses slightly inset color range

if (size(Y,2) > 19)
  clrs = jet(floor(size(Y,2).*1.2));
  set(gca,'ColorOrder',flipdim(clrs(...
                                     floor((size(clrs,1)-size(Y,2))/2)...
                                    -1+(1:size(Y,2)),:),1));
else
    clrs = jet(size(Y,2)+2);
    set(gca, 'ColorOrder', flipdim(clrs(2:(end-1),:),1));
endif

set(gca,'ticklength',[0.025 0.025]);
set(gca,'xminortick','on');
set(gca,'yminortick','on');
hold("all");
A.p = plot(X,Y);

% Tick settings

% Labels
if (nargin > 2)
  xlabel(xLab);
endif
if (nargin > 3)
  ylabel(yLab);
endif

% Legend
if (nargin > 4)
  legText = cell(1,size(Y,2));                  % Cell array same size as n
  legText(1:size(Y,2)) = {""};                  % Empty text does not show
  legText(legendPoints) = legendTitles;         % Legend titles inserted into correct pos
  A.l = legend(legText,'location',legendPos);   % Location (no fine tuning alowed)
endif

% Linewidth
if (nargin > 7)
  set(findall(gcf,'-property','linewidth'),'linewidth',lw);
endif

hold("off");

endfunction
