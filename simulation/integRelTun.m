function res = integRelTun(y,ind,psi,n,n0,psib,NSR,T,PC)

res = zeros(length(psi),length(psib),length(NSR));
o2 = ones(1,length(psib));
o3 = ones(1,length(NSR));

y = y';

phit = PC.kB.*T./PC.e;
m = psib./phit;
o1 = ones(1,length(n));
delNS = permute(n0./n(:,o3).*(1-NSR(o1,:))+NSR,[1 3 2]);

for k=1:length(psi)
  indk = find(ind(k,:));
  if (length(indk)>1)
    o1 = ones(1,length(indk));
    res(k,:,:) = trapz(y(indk,k.*o2,o3),exp(-1./sqrt(delNS(indk,o2,:).*(m(o1,:,o3)+psi(indk,o2,o3)./phit))));
  endif
endfor
endfunction
