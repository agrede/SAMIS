function res = sepCap(psis,Qc,n,p,N,kappas,PC,Cox,Cit)
% SEPCAP separates capacitance into diffferent components
%
% RES = SEPCAP(PSIS,QC,N,P,N,KAPPAS,PC)
%       PSIS    = surface potential
%       QC      = Channel Charge
%       N       = electron concentrations (column for each type)
%       P       = hole concentrations (column for each type)
%       N       = ionized dopant concentrations (column for each species)
%       KAPPAS  = relitive dielectric constant for semiconductor
%       PC      = physical constants
%       
% RES = SEPCAP(PSIS,QC,N,P,N,KAPPAS,PC,COX,CIT)
%       COX     = dielectric capacitance
% RES = SEPCAP(PSIS,QC,N,P,N,KAPPAS,PC,COX,CIT)
%       CIT     = interface state capacitance
%
% Output RES:
%       y,ind   = position by psi (see YBYETA)
%       Qce     = excess electron charge in channel
%       Qch     = excess hole charge in channel
%       QcI     = excess ionization charge in channel
%       nFB     = electron concentration at flat-band
%       pFB     = hole concentration at flat-band
%       NFB     = ionized impurity concentration at flat-band
%       Cce     = channel capacitance components of electrons
%       Cch     = channel capacitance components of holes
%       CcI     = channel capacitance components of ionized impurities
%       CcD     = depletion width capacitance
%                
% Additional parameters add additional outputs to RES:
%       Cgblh   = Cgb less holes
%       Cgboe   = Cgb only electrons
%       CgblI   = Cgb less ionization
%       CgbeI   = Cgblh less interface states
%       Cgble   = Cgb less electrons
%       Cgboh   = Cgb only holes
%       CgbhI   = Cgble less interface states
%
% Copywrite (C) 2013 Alex J. Grede
% GPL v3, See LICENSE.txt for details
% This function is part of SAMIS (https://github.com/agrede/SAMIS)

% Initialize
res = struct;

res.Qce = zeros(length(psis),size(n,2));
res.Qch = zeros(length(psis),size(p,2));
res.QcI = zeros(length(psis),size(N,2));

% Solve for y
[res.y,res.ind] = yByEta(psis,Qc,kappas,PC);

% Interpolate for flat-band
res.pFB = exp(interp1(psis,log(p),0,'spline'))';
res.nFB = exp(interp1(psis,log(n),0,'spline'))';
res.NFB = sign(N).*exp(interp1(psis,log(abs(N)),0,'spline'))';

% Set up some common ones matricies 
on = ones(1,size(n,2));
op = ones(1,size(p,2));
oN = ones(1,size(N,2));

for k=1:length(psis)            % Loop for each psis
  indk = find(res.ind(k,:));    % Valid y indicies
  if (length(indk)>1)           % More than 1 point
    oik = ones(1,length(indk)); % ones vector for number of valid indicies

    % Electrons
    res.Qce(k,:) = -sign(psis(k,on)).*PC.e.*...
                    trapz(res.y(k.*on,indk)',...
                          (res.nFB(oik,:)-n(indk,:)));

    % Holes
    res.Qch(k,:) = sign(psis(k,op)).*PC.e.*...
                   trapz(res.y(k.*op,indk)',...
                         (res.pFB(oik,:)-p(indk,:)));
    
    % Ions
    res.QcI(k,:) = sign(psis(k,oN)).*PC.e.*...
                   trapz(res.y(k.*oN,indk)',...
                         (res.NFB(oik,:)-N(indk,:)));
  endif
endfor

% Calc capacitances
res.Cce = -(eqLenDiff(res.Qce')./eqLenDiff(psis(:,on)'))';
res.Cch = -(eqLenDiff(res.Qch')./eqLenDiff(psis(:,op)'))';
res.CcI = -(eqLenDiff(res.QcI')./eqLenDiff(psis(:,oN)'))';
res.CcD = PC.epsilon0.*kappas./max(res.y,[],2);

% Additional calculations
if (nargin > 7)
   if (nargin < 9)
      Cit = 0;
   endif
   res.Cgblh = (1./Cox+1./(sum(res.Cce,2)+sum(res.CcI,2)+Cit)).^(-1);
   res.Cgboe = (1./Cox+1./(sum(res.Cce,2))).^(-1);
   res.CgblI = (1./Cox+1./(sum(res.Cce,2)+sum(res.Cch,2)+Cit)).^(-1);
   res.CgbeI = (1./Cox+1./(sum(res.Cce,2)+sum(res.CcI,2))).^(-1);
   res.Cgble = (1./Cox+1./(sum(res.Cch,2)+sum(res.CcI,2)+Cit)).^(-1);
   res.Cgboh = (1./Cox+1./(sum(res.Cch,2))).^(-1);
   res.CgbhI = (1./Cox+1./(sum(res.Cch,2)+sum(res.CcI,2))).^(-1);
endif

endfunction
