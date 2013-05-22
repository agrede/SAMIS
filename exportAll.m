function res = exportAll()
% EXPORTALL exports data from DITA using exportCV funciton
  path = uigetdir("./","Export to Folder");
  exportCV(path,DITA.Meas,DITA.Sim,DITA.Term,DITA.Nicol,DITA.Cast,...
           DITA.Cox,DITA.corToUse,DITA.refIndex,PC);
endfunction
