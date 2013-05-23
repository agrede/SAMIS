function [y,ind] = yByEta(psis,Qc,kappa,PC)

dely = cumtrapz(psis,-PC.epsilon0.*kappa./Qc);

y = zeros(length(psis),length(psis));

ind0 = [0 0];

if (~isempty(find(psis==0)))
   ind0 = find(psis==0,1).*[1 1];
else
   ind0 = find(psis>0,1).*[1 1]-[1 -1];
endif

idx = (1:length(dely))'*ones(1,length(dely));
ind = ((idx'>=idx).*(idx'<=ind0(1)))+((idx'<=idx).*(idx'>=ind0(2)));
y = dely(:,ones(1,length(dely)))-dely(:,ones(1,length(dely)))';
y(logical(~ind)) = nan;


endfunction
