function H = plotLoadMeas(Ref)
% PLOTLOADMEAS plots accuracy of load corrections
%   H = PLOTLOADMEAS(REF)
%       REF     struct array from load CF measurements
%
% Copywrite (C) 2013 Alex J. Grede
% GPL v3, See LICENSE.txt for details
% This function is part of SAMIS (https://github.com/agrede/SAMIS)

  % Init -----------------------------------------------------------------------
  o2 = ones(1,size(Ref.f,2));   % Useful ones vector
  [tmp,k] = sort(Ref.Cr);       % k gives proper ordered caps
  fmt = '%.0d pF LoadCorr';     % Format string for legend

  % Determine matrix arangement --------
  N = length(Ref.Cr);
  cols = ceil(sqrt(N));
  rows = ceil(N./cols);
  % Generate plots -------------------------------------------------------------
  for n=1:N
    l = 1; % legend index
    leg = {};
    % Uncorrected and Open/Short Correctoins -----
    C = [Ref.Crm(k(n),:);Ref.Cor.osc.C(k(n),:)];
    leg(l:l+1) = {'As Measured','Open/Short Corr'};
    l = l+2;
    
    % Corrections using one size cap down
    if (n>1)
      C = [C;Ref.Cor.LC.C(k(n),:,k(n-1))];
      leg{l} = sprintf(fmt,Ref.Cr(k(n-1)).*1e12);
      l++;
    endif

    % Corrections useing one size capacitor up ---
    if (n<N)
      C = [C;Ref.Cor.LC.C(k(n),:,k(n+1))];
      leg{l} = sprintf(fmt,Ref.Cr(k(n+1)).*1e12);
      l++;
    endif

    % Get Error Bars and Targets -----------------
    Crer = (Ref.err.Cr(k(n))*[1;-1]+Ref.Cr(k(n)))*o2;
    Cr = Ref.Cr(k(n)).*o2;
    leg(l:l+2) = {'','','Target'};

    % Plots --------------------------------------
    subplot(rows,cols,n);
    semilogx(Ref.f(1,:)',C'.*1e12,'x');         % Plot measurment data
    hold on;
    semilogx(Ref.f(1,:)',Crer'.*1e12,'k--');    % Plot error bars
    semilogx(Ref.f(1,:)',Cr'.*1e12,'k');        % Plot target
    hold off;

    % Formatting ---------------------------------
    % Labels
    legend(leg);
    title(sprintf('%.0d pF Reference',Ref.Cr(k(n)).*1e12));
    ylabel('Capacitance [pF]');
    xlabel('Frequency [Hz]');
    % Ticks
    set(gca,'xscale','log');
    set(gca,'xminortick','on');
    set(gca,'yminortick','on');
  end

endfunction
