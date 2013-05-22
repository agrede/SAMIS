function f = allFactors(n)
if (n==0)
   f = n;
   return
elseif(n<0)
  n = abs(n);
end

N = factor(n);
f = [];
for k = 2:(length(N)-1)
  f = [f,unique(prod(nchoosek(N,k),2))'];
endfor

f = sort([1,unique(N),f,n]);

endfunction
