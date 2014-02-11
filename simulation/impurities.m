function NI = impurities(eta,etaV,Imps,T,ImpProps,PC)
  % IMPURITIES calculates the number of ionized impurites
  % Returns a matrix of len(eta)x(#impurities)
  % Acceptor concentrations will be returned as negative numbers
  %
  % NI = IMPURITIES(ETA,ETAV,IMPS,T,IMPPROPS,PC)
  %    ETA      = relative energy
  %    ETAV     = relative energy of the valance band edge
  %    IMPS     = impurities array with concentration in m^-3
  %               element abreviation or ionization energy in meV
  %               and type
  %    T        = temperature in K
  %    IMPPROPS = contains ionization energies for different elements
  %    PC       = physical constants
  %
  % Copyright (C) 2013 Alex J. Grede
  % GPL v3, See LICENSE.txt for details
  % This function is part of SAMIS (https://github.com/agrede/SAMIS)

  NI = zeros(size(eta,1),length(Imps));
  for k=1:length(Imps)
    etaI = nan;                         % Ionization energy
    iType = 1;                          % 0 = Acceptor, 1 = Donor
    iPropT = 'Donors';                  % Used in ImpProps

    % Determine type
    if (strcmpi(Imps{k}.type,'A'))
      iType = 0;
      iPropT = 'Acceptors';
    endif

    if (isfield(Imps{k},'energy'))                      % Prefer given energy
       etaI = Imps{k}.energy.*1e-3.*PC.e./(PC.kB.*T);
    elseif (isfield(Imps{k},'element'))                 % or Lookup element
      etaI = 0; % uses 0 as a fallback if element does not exist in ImpProps
      if (isfield(ImpProps,iPropT))
        if (isfield(ImpProps.(iPropT),Imps{k}.element))
          etaI = ImpProps.(iPropT).(Imps{k}.element)./(PC.kB.*T);
        endif
      endif
    endif

    % Calculate ionization concentrations
    if (iType)  % n-type
      if (~isnan(etaI))
        NI(:,k) = (Imps{k}.concentration)./(1+2.*exp(eta+etaI));
      else % nan gives ideal or fully ionized
        NI(:,k) = Imps{k}.concentration;
      endif
    else        % p-type
      if (~isnan(etaI))
        NI(:,k) = -(Imps{k}.concentration)./(1+4.*exp(-eta+etaV+etaI));
      else % nan gives ideal or fully ionized
        NI(:,k) = -Imps{k}.concentration;
      endif
    endif
  endfor
endfunction
