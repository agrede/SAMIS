function H = plotPsiByY(psi,y,ind,PC,n)

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
