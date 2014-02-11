function yp = dydx(x,pp,order)
  % DYDX uses cubic spline interpolation parameters to calc derivatives
  %
  % YP = DYDX(X,PP,ORDER)
  %     X       = x points to evaluate
  %     PP      = struct containing interpolation parameters
  %     ORDER   = derivative order
  %
  % Copyright (C) 2013--2014 Alex J. Grede
  % GPL v3, See LICENSE.txt for details
  % This function is part of SAMIS (https://github.com/agrede/SAMIS)


  k = lookup(pp.breaks(1:end-1),x); % Find closest interp breakpoints for each x
  o1 = ones(length(x),1);

  X = (x(:,ones(1,4))-pp.breaks(ones(1,4),k)'); % Only difference from breakpoints
  D = [1 3 6 6;1 2 2 0;1 1 0 0;1 0 0 0]; % coefficients for derivitive orders
  if (order < 0) % 0th order returns 0
    yp = 0.*o1;
  elseif (order < 4) % Coeffients only work up to 3rd order
    DE = zeros(1,4);
    DE(1:(3-order)) = (3-order):-1:1;
    yp = (pp.coefs(k,:).*X.^DE(o1,:))*D(:,order+1);
    if ((order == 3)*(x(end)>pp.breaks(end-1))) % Needs additional calculion for endpoint in 3rd order
      DE = [1 0 0 0];
      ytmp  = [6.*pp.coefs(:,1);6.*pp.breaks(end).*pp.coefs(end,1)+2.*pp.coefs(end,2)];
      pptmp = interp1(pp.breaks',ytmp,'spline','pp');
      yp(end) = (pptmp.coefs(end,:).*X(end,:))*D(:,2);
    endif
  else % Use derivative and calculate the higher order derivative from this
    DE = [1 0 0 0];
    ytmp  = [6.*pp.coefs(:,1);6.*pp.breaks(end).*pp.coefs(end,1)+2.*pp.coefs(end,2)];
    pptmp = interp1(pp.breaks',ytmp,'spline','pp');
    yp = dydx(x,pptmp,order-2);
  endif
endfunction
