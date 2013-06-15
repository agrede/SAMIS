function NI = impurities(eta,etaV,Imps,T,ImpProps,PC)
  % 
  NI = zeros(size(eta,1),length(Imps));
  for k=1:length(Imps)
    etaI = nan;
    iType = 1;
    iPropT = 'Donors';
    if (strcmpi(Imps{k}.type,'A'))
      iType = 0;
      iPropT = 'Acceptors';
    endif
    if (isfield(Imps{k},'energy'))
       etaI = Imps{k}.energy.*1e-3.*PC.e./(PC.kB.*T);
    elseif (isfield(Imps{k},'element'))
      etaI = 0;
      if (isfield(ImpProps,iPropT))
        if (isfield(ImpProps.(iPropT),Imps{k}.element))
          etaI = ImpProps.(iPropT).(Imps{k}.element)./(PC.kB.*T); 
        endif
      endif
    endif
    if (iType)
      if (~isnan(etaI))
        NI(:,k) = (Imps{k}.concentration)./(1+2.*exp(eta+etaI));
      else
        NI(:,k) = Imps{k}.concentration;
      endif
    else
      if (~isnan(etaI))
        NI(:,k) = -(Imps{k}.concentration)./(1+4.*exp(-eta+etaV+etaI));
      else
        NI(:,k) = -Imps{k}.concentration;
      endif
    endif
  endfor
endfunction
