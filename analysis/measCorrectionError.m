function [res,comp] = measCorrectionError(ref,meas,HP,ITR,ITM,VacR,VacM,VdcR,Cl,T)
%
% Copyright (C) 2013 Alex J. Grede
% GPL v3, See LICENSE.txt for details
% This function is part of SAMIS (https://github.com/agrede/SAMIS)

f = ref.f;

o1 = ones(1,size(meas.Z,1));
o2 = ones(1,length(f));
o3 = ones(1,length(ref.Cr));

Zom = ref.Zom;
tmp = measAccuracy(f,Zom,HP,ITR,VacR,VdcR,Cl,T);
eZom = Zom.^2.*((0.01.*tmp.A).^2-(tmp.theta./angle(Zom)).^2);
Zsm = ref.Zsm;
tmp = measAccuracy(f,Zsm,HP,ITR,VacR,VdcR,Cl,T);
eZsm = Zsm.^2.*((0.01.*tmp.A).^2-(tmp.theta./angle(Zsm)).^2);
Zrm = permute(ref.Zrm,[3,2,1]);
tmp = measAccuracy(f,ref.Zrm,HP,ITR,VacR,VdcR,Cl,T);
eZrm = Zrm.^2.*permute(((0.01.*tmp.A).^2-(tmp.theta./angle(ref.Zrm)).^2),[3,2,1]);
Zr = permute(ref.Zr,[3,2,1]);
eZr = Zr.^2.*permute(((ref.Cr(:,o2).*0.005+0.1e-12)./ref.Cr(:,o2)).^2,[3,2,1]);
Zm = meas.Z;
tmp = measAccuracy(f,Zm,HP,ITM,VacM,meas.V,Cl,T);
eZm = Zm.^2.*((0.01.*tmp.A).^2-(tmp.theta./angle(Zm)).^2);
comp = cat(4,...
           eZr(o1,:,:)./(Zr(o1,:,:)).^2,...
           eZrm(o1,:,:).*(1./(Zrm(o1,:,:)-Zom(o1,:,o3)).^2+1./(Zsm(o1,:,o3)-Zrm(o1,:,:)).^2),...
           eZsm(o1,:,o3).*(1./(Zsm(o1,:,o3)-Zrm(o1,:,:)).^2+1./(Zsm(o1,:,o3)-Zm(:,:,o3)).^2),...
           eZom(o1,:,o3).*(1./(Zrm(o1,:,:)-Zom(o1,:,o3)).^2+1./(Zm(:,:,o3)-Zom(o1,:,o3)).^2),...
           eZm(:,:,o3).*(1./(Zsm(o1,:,o3)-Zm(:,:,o3)).^2+1./(Zm(:,:,o3)-Zom(o1,:,o3)).^2));
res = sqrt(                                                            ...
           eZr(o1,:,:)./(Zr(o1,:,:)).^2                                ...
          +(eZrm(o1,:,:)+eZom(o1,:,o3))./(Zrm(o1,:,:)-Zom(o1,:,o3)).^2 ...
          +(eZsm(o1,:,o3)+eZrm(o1,:,:))./(Zsm(o1,:,o3)-Zrm(o1,:,:)).^2 ...
          +(eZsm(o1,:,o3)+eZm(:,:,o3))./(Zsm(o1,:,o3)-Zm(:,:,o3)).^2   ...
          +(eZm(:,:,o3)+eZom(o1,:,o3))./(Zm(:,:,o3)-Zom(o1,:,o3)).^2);

endfunction
