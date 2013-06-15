function F = jaegerF(u,h,rhoPP,C)
  k = 2:length(u)-1;
  F = (h(k)+h(k+1)).*(u(k-1)+u(k+1)-u(k)-0.5.*C.*h(k).*h(k+1).*dydx(u(k),rhoPP,0));
endfunction
