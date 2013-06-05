function H = plotCombinedDit(VGB,Term,Nicol,Cast,PC)
% PLOTCOMBINEDDIT plots all methods DIT on one chart
%  H = PLOTCOMBINEDDIT(VGB,TERM,NICOL,CAST,PC)
%       VGB     bias to plot against (column vector)
%       TERM    res of Terman method 
%       NICOL   res of Nicollian and Goetzberger 
%       CAST    res of Cast and Vapallie 
%
%       Use empty struct to ingnore any of these
%
% See also TERMANMETHOD, NICOLLIANGOETZBERGER, CASTAGNEANDVAPAILLE
%
% Copywrite (C) 2013 Alex J. Grede
% GPL v3, See LICENSE.txt for details
% This function is part of SAMIS (https://github.com/agrede/SAMIS)

  % Populate Dit values --------------------------------------------------------
  k = 1;
  leg = {};
  Dit = zeros(size(VGB,1),0);
  if (isfield(Term,'Dit'))
    Dit(:,k) = Term.Dit;
    leg{k} = 'Terman (High-Frequency)';
    k = k+1;
  endif
  if (isfield(Nicol,'Dit'))
    Dit(:,k) = Nicol.Dit;
    leg{k} = 'Nicollian and Goetzberger (Conductance)';
    k = k+1;
  endif
  if (isfield(Cast,'Dit'))
    Dit(:,k)   = Cast.Dit;
    leg{k} = 'Castagne and Vapaille (High-Low)';
  endif

  Dit = 1e-4.*Dit.*PC.e; % Unit conversion;

  % Plot -----------------------------------------------------------------------

  semilogy(VGB(:,1),Dit);

  % Formating --------------------------
  % Labels
  legend(leg);
  xlabel('Applied Bias [V]');
  ylabel('Interface State Denisty [1/(cm^2 eV)]');

  % Better ticks and formating
  set(gca,'yscale','log');
  set(gca,'xminortick','on');
  set(gca,'yminortick','on');
endfunction
