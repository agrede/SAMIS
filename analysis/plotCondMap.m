function A = plotCondMap(V,f,Gpomega,Vsig,PC,M,crng,lw)
% PLOTCONDMAP plots contour of 2.5*Gp/Aomegaq^2 vs bias and freq
%   A = PLOTCONDMAP(V,F,GPOMEGA,VSIG,PC)
%       V       bias voltage
%       F       frequency
%       Gpomega conductance density divided by angular freq
%       VSIG    ac-signal [Vrms]
%       PC      physical constants
%   A = PLOTCONDMAP(V,F,GPOMEGA,VSIG,PC,M)
%       M       force magnitude 12-> plot will be in 10^12/(cm^2 eV)
%   A = PLOTCONDMAP(V,F,GPOMEGA,VSIG,PC,M,CRNG)
%       CRNG    force range for z-axis (note the units from setting M)
%   A = PLOTCONDMAP(V,F,GPOMEGA,VSIG,PC,M,CRNG,LW)
%       LW      line width, can be useful for exporting
%
% See also CONTOURF
%
% Copyright (C) 2013--2016 Alex J. Grede
% GPL v3, See LICENSE.txt for details
% This function is part of SAMIS (https://github.com/agrede/SAMIS)

% Initialize variables ---------------------------------------------------------
if (nargin < 6) % Find nearest power of 1000 in cm^-3 eV to set magnitude
  M = 3.*floor(median(log(Gpomega(logical(Gpomega>0)).*1e-4./PC.e)./log(10))./3);
endif

X = V(:,ones(1,length(f)));
Y = f(ones(1,size(V,1)),:);
Z = 2.5.*10.^(-(M+4)).*Gpomega./PC.e;


% Plot -------------------------------------------------------------------------
set(0,'Defaulttextfontsize',20);

contourf(X,Y,Z);

% Customize apearance ----------------------------------------------------------
set(gca,'yscale','log');

% Ticks
set(gca,'ticklength',[0.025 0.025]);
set(gca,'xminortick','on');
set(gca,'yminortick','on');

% Axes labels
xlabel('Applied Bias [V]');
ylabel('Frequency [Hz]');

% Line width
if (nargin > 7)
  set(findall(gcf,'-property','linewidth'),'linewidth',4);
endif

% Colors Bar----------------------------
colormap(flipdim(bone(10),1));

% Range
if (nargin > 6)
   caxis(crng)
endif

% Make colorbar
hc = colorbar('NorthOutside');

% Colorbar label
set(get(hc,'xlabel'),'string',...
    strcat('Gp/(omegaAq^2) [ x 1e', sprintf('%d',M), '1/(cm eV)]'));

% Pos of color bar
pos1 = get(gca,'pos');
pos2 = get(hc,'pos');
set(hc,'pos',[pos1(1) pos1(2)+pos1(4)+0.01 pos1(3) pos2(4)])

% Vac text -----------------------------
% Attempts to put the label in the lowest mag spot
%  so it can be read
if (~isnan(Vsig))
  [m1,k1] = min(Gpomega,[],1);
  [m2,k2] = min(m1);
  if (k1(k2) < size(Gpomega,1)./2)
    n1 = k1(k2)+1;
  else
    n1 = k1(k2)-1;
  endif
  if (k2 < size(Gpomega,2)./2)
    n2 = k2+1;
  else
    n2 = k2-1;
  endif
  text(X(n1,n2),Y(n1,n2),strcat('Vac = ', sprintf('%d [mVrms]',1e3.*Vsig)));
endif

endfunction
