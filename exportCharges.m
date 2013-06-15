function res = exportCharges(path,psis,VGB,Qc,Caps)

  Qsep = [Caps.Qce Caps.Qch Caps.QcI];
  o2 = ones(1,size(Qsep,2));
  csvwrite(path,[VGB psis Qc Qsep]);

endfunction
