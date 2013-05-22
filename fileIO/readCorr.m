function rtn = readCorr(path,cal)
% READCORR Reads correction files and generates ref for making corrections
%   RTN = READCORR(PATH,CAL)
%       PATH    path to folder containing correction measurements
%       CAL     calibration file for correction measurements
%
%       Files must be named as referecne_values section indicates
%         ex: 10pF.xls corrisponds to reference_values.r10pF
%       Is only setup to deal with load capacitors at the moment
%       Must all be tested at same frequencies
%       Extra files can cause problems

% Initialize -------------------------------------------------------------------
  rtn = struct;
  rtn.err = struct;
  rtn.stdev = struct;

  rtn.fmismatch = 0; % Indicates if frequencies of files were not the same

  % Short Circuit Measurements
  rtn.Zsm = [];
  rtn.stdev.Zsm = [];
  rtn.Ysm = [];
  rtn.stdev.Ysm = [];

  % Open Circuit Measurements
  rtn.Zom = [];
  rtn.stdev.Zom = [];

  % Reference measurements
  rtn.Zrm = [];
  rtn.stdev.Zrm = [];

  % Reference Capacitors
  rtn.Cr = [];
  rtn.err.Cr = [];

  % Ideal Ref at different frequencies
  rtn.Zr = [];
  rtn.Yr = [];

  % Measured capacitance values by frequency
  rtn.Crm = [];
  rtn.stdev.Crm = [];

  % Used for measCorrection
  rtn.Z = [];
  rtn.f = [];
  
  cal_values = loadjson(cal);

  paths = glob(strcat(path,"*.xls"));
  k = 1; % Counter for reference capacitors
  for n = 1:length(paths)
    [tmpS,tmpE,tmpTE,tmpM,tmpT,tmpNM,tmpSP] = regexp(paths{n},"([^\\./]*)\\.xls$");
    calStd = strcat("r",tmpT{1}{1});
    if (isfield(cal_values.reference_values,calStd))
       tmpStd = cal_values.reference_values.(calStd);
       tmp = readCF(paths{n});
       
       if (n==1) % Set frequency
         rtn.f = tmp.f(1,:);
       elseif (size(rtn.f,2) == size(tmp.f,2) && ~rtn.fmismatch) % Make sure freq never changes
         rtn.fmismatch = prod(rtn.f==tmp.f(1,:));
       else
         rtn.fmismatch = 1;
       endif
       
       if (strcmp(tmpStd.type,"short"))
         rtn.Zsm       = nanmean(tmp.Z,1);
         rtn.stdev.Zsm = std(tmp.Z,0,1);
         rtn.Ysm       = nanmean(tmp.Y,1);
         rtn.stdev.Ysm = std(tmp.Y,0,1);
       elseif (strcmp(tmpStd.type,"open"))
         rtn.Zom       = nanmean(tmp.Z,1);
         rtn.stdev.Zom = std(tmp.Z,0,1);
         rtn.Yom       = nanmean(tmp.Y,1);
         rtn.stdev.Yom = std(tmp.Y,0,1);
       elseif (strcmp(tmpStd.type,"capacitor"))
         rtn.Zrm(k,:)       = nanmean(tmp.Z,1);
         rtn.stdev.Zrm(k,:) = std(tmp.Z,0,1);
         rtn.Yrm(k,:)       = nanmean(tmp.Y,1);
         rtn.stdev.Yrm(k,:) = std(tmp.Y,0,1);
         rtn.Crm(k,:)       = nanmean(tmp.C,1);
         rtn.stdev.Crm(k,:) = std(tmp.C,0,1);
         rtn.Grm(k,:)       = nanmean(tmp.G,1);
         rtn.stdev.Grm(k,:) = std(tmp.G,0,1);
         
         tmpImp = findImpParams(1,tmp.f(1,:),0,tmpStd.C);
         rtn.Cr(k,1)     = tmpStd.C;
         rtn.err.Cr(k,1) = tmpStd.C_error;
         rtn.Zr(k,:)     = tmpImp.Z;
         rtn.Yr(k,:)     = tmpImp.Y;

         k++;
       endif
    else
      calStd
    endif
  endfor
  rtn.LC = loadCorr(rtn.Zom,rtn.Zsm,rtn.Zrm,rtn.Zr);
  rtn.Z = rtn.Zrm;
  rtn.Cor.osc = measCorrection(rtn.Zom,rtn.Zom,rtn.Zsm,rtn);
  rtn.Cor.LC  = measCorrection(rtn.LC,rtn.Zom,rtn.Zsm,rtn);
  
endfunction
