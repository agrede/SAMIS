function H = plotPsiByY(psi,y,ind,PC,n)
  % PLOTPSIBYY plots psi vs y for multiple psis values
  %
  % H = PLOTPSIBYY(PSI,Y,IND,PC)
  %     PSI     = potential
  %     Y       = y matrix from YBYETA
  %     IND     = ind matrix from YBYETA
  %     PC      = physical constants
  %
  % H = PLOTPSIBYY(PSI,Y,IND,PC,N)
  %     N       = only plot for psis at indicies in N
  %               (otherwise it can be easy to get 1000s of lines)
  % See also: YBYETA
  %
  % Copywrite (C) 2013 Alex J. Grede
  % GPL v3, See LICENSE.txt for details
  % This function is part of SAMIS (https://github.com/agrede/SAMIS)

  if (nargin < 4)
    n = 1:length(psi);
  endif

  color = jet(length(n));

  fst = 1;
  for k1=1:length(n)
    k = n(k1);
    semilogy(y(k,logical(ind(k,:))),psi(logical(ind(k,:))),'Color',color(k1,:));
    if (fst)
       hold on;
    endif
  endfor
  hold off;
endfunction
