function res = exportCaps(path,psis,Cgb,Cox,VGB,Cc,Qc,Caps,k)
  % EXPORTCAPS exports data to csv file from SEPCAPS data
  %
  % RES = EXPORTCAPS(PATH,PSIS,CGB,COX,VGB,CC,QC,CAPS)
  %     PATH    = file path to save
  %     PSIS    = surface potential
  %     CGB     = ideal cgb
  %     COX     = dielectric capacitance
  %     VGB     = ideal VGB
  %     CC      = total channel capacitance
  %     QC      = total channel charge
  %     CAPS    = struct from SEPCAPS
  % RES = EXPORTCAPS(PATH,PSIS,CGB,COX,VGB,CC,QC,CAPS, K)
  %     K       = sample points to export (default is all)
  %
  % SEE ALSO: SEPCAPS
  %
  % Copyright (C) 2013--2016 Alex J. Grede
  % GPL v3, See LICENSE.txt for details
  % This function is part of SAMIS (https://github.com/agrede/SAMIS)
  if (nargin < 9)
    k = 1:length(psis);
  endif
  Csep = [Caps.Cce(k,:) sum(Caps.Cce(k,:),2) Caps.Cch(k,:) sum(Caps.Cch(k,:),2) Caps.CcI(k)];
  Qsep = [Caps.Qce(k,:) sum(Caps.Qce(k,:),2) Caps.Qch(k,:) sum(Caps.Qch(k,:),2) Caps.QcI(k,:)];
  o2 = ones(1,size(Csep,2));
  csvwrite(path,[VGB(k) psis(k) Cgb(k) Cgb(k)./Cox Cc(k) Csep Csep./Cc(k,o2) Qc(k) Qsep Qsep./Qc(k,o2)]);
endfunction
