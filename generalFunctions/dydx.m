function yp = dydx(x,pp,order)
  k = lookup(pp.breaks(1:end-1),x);
  o1 = ones(length(x),1);
  
  X = (x(:,ones(1,4))-pp.breaks(ones(1,4),k)');
  D = [1 3 6 6;1 2 2 0;1 1 0 0;1 0 0 0];
  if (order < 0)
    yp = 0.*o1;
  elseif (order < 4)
    DE = zeros(1,4);
    DE(1:(3-order)) = (3-order):-1:1;
    yp = (pp.coefs(k,:).*X.^DE(o1,:))*D(:,order+1);
    if ((order == 3)*(x(end)>pp.breaks(end-1)))
      DE = [1 0 0 0];
      ytmp  = [6.*pp.coefs(:,1);6.*pp.breaks(end).*pp.coefs(end,1)+2.*pp.coefs(end,2)];
      pptmp = interp1(pp.breaks',ytmp,'spline','pp');
      yp(end) = (pptmp.coefs(end,:).*X(end,:))*D(:,2);
    endif
  else
    DE = [1 0 0 0];
    ytmp  = [6.*pp.coefs(:,1);6.*pp.breaks(end).*pp.coefs(end,1)+2.*pp.coefs(end,2)];
    pptmp = interp1(pp.breaks',ytmp,'spline','pp');
    yp = dydx(x,pptmp,order-2);
  endif
endfunction
