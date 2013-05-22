function res = openShortCorr(refo,refs,meas)


res = meas;

Zo = interp1(log(refo.f),refo.Z,log(meas.f),'spline')*ones(size(meas,1),1);
Zs = interp1(log(refo.f),1./(refs.Y-refo.Y),log(meas.f),'spline')*ones(size(meas,1),1);

res.Z = -((Zs-Zo).*meas.Z-Zs.*Zo)./(meas.Z-Zo);
res.Y = 1./res.Z;

res.G = real(res.Y);
res.C = imag(res.Y)./(meas.f(ones(1,size(meas.C,1)),:).*2.*pi);

endfunction
