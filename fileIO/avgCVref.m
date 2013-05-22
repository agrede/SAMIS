function res = avgCVref(ref)

res.C = mean(ref.C,1);
res.G = mean(ref.G,1);

res.f = ref.f;

res.Y = res.G+I.*2.*pi.*res.f.*res.C;
res.Z = 1./res.Y;

endfunction
