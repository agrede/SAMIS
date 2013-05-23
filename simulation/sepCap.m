function res = sepCap(psis,Qc,n,p,N,kappas,PC,Cox,Cit)

res = struct;

[res.y,res.ind] = yByEta(psis,Qc,kappas,PC);

res.Qce = zeros(length(psis),size(n,2));
res.Qch = zeros(length(psis),size(p,2));
res.QcI = zeros(length(psis),size(N,2));

res.pFB = exp(interp1(psis,log(p),0,'spline'))';
res.nFB = exp(interp1(psis,log(n),0,'spline'))';
res.NFB = sign(N).*exp(interp1(psis,log(abs(N)),0,'spline'))';

on = ones(1,size(n,2));
op = ones(1,size(p,2));
oN = ones(1,size(N,2));

for k=1:size(res.Qce,1)
    indk = find(res.ind(k,:));
    oik = ones(1,length(indk));
    res.Qce(k,:) = -sign(psis(k,on)).*PC.e.*...
                   trapz(res.y(k.*on,indk),...
                     (res.nFB(oik,:)-n(indk,:))')';
    res.Qch(k,:) = sign(psis(k,op)).*PC.e.*...
                   trapz(res.y(k.*op,indk),...
                     (res.pFB(oik,:)-p(indk,:))')';
    res.QcI(k,:) = sign(psis(k,oN)).*PC.e.*...
                   trapz(res.y(k.*oN,indk),...
                     (res.NFB(oik,:)-N(indk,:))')';
endfor

res.Cce = -(eqLenDiff(res.Qce')./eqLenDiff(psis(:,on)'))';
res.Cch = -(eqLenDiff(res.Qch')./eqLenDiff(psis(:,op)'))';
res.CcI = -(eqLenDiff(res.QcI')./eqLenDiff(psis(:,oN)'))';

if (nargin > 7)
   if (nargin < 8)
      Cit = 0;
   endif
   res.Cgblh = (1./Cox+1./(sum(res.Cce,2)+sum(res.CcI,2)+Cit)).^(-1);
   res.Cgboe = (1./Cox+1./(sum(res.Cce,2))).^(-1);
   res.CgblI = (1./Cox+1./(sum(res.Cce,2)+sum(res.Cch,2)+Cit)).^(-1);
   res.CgbeI = (1./Cox+1./(sum(res.Cce,2)+sum(res.CcI,2))).^(-1);
   res.Cgble = (1./Cox+1./(sum(res.Cch,2)+sum(res.CcI,2)+Cit)).^(-1);
   res.Cgboh = (1./Cox+1./(sum(res.Cch,2))).^(-1);
   res.CgbhI = (1./Cox+1./(sum(res.Cch,2)+sum(res.CcI,2))).^(-1);
endif

endfunction
