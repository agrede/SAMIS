function res = measCorrection(LC,Zom,Zsm,meas)
% MEASCORRECTION returns measurments with corrected values
%   RES = MEASCORRECTION(LC,ZOM,ZSM,MEAS)
%       LC      load correction (can also use ZOM for symetric assumption)
%               is k x m  matrix (k being differrent load corrections)
%       ZOM     open circuit measured impedance 1 x m matrix
%       ZSM     short circuit measured impedance 1 x m matrix
%       meas    meas data
%               meas.Z is n x m matrix with m changes in freq
%               meas.f is n x m or 1 x m with m changes in freq
%
%       RES     returns n x m x k with corrections for each different LC
%
%  NOTE: all measurements must be at same frequency steps

res = meas;

o1 = ones(1,size(meas.Z,1));
o3 = ones(1,size(LC,1));

LC = permute(LC,[3,2,1]);

res.Z = LC(o1,:,:).*(Zsm(o1,:,o3)-meas.Z(:,:,o3))./(meas.Z(:,:,o3)-Zom(o1,:,o3));
res.Y = 1./res.Z;
res.G = real(res.Y);
res.C = imag(res.Y)./(2.*pi.*res.f(o1,:,o3));

endfunction
