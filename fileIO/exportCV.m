function res = exportCV(path,Meas,Sim,Term,Nicol,Cast,Cox,corTyp,corInd,PC)
% EXPORTCV Exports data to csv files for use in other software
%   RES = EXPORTCV(PATH,MEAS,SIM,TERM,NICOL,CAST,COX,CORTYPE,CORIND,PC)
%       PATH    path to folder where all will be stored
%       MEAS    meas data struct
%       SIM     sim data struct
%       TERM    Terman method data struct
%       NICOL   Nicollian and Goetzberger data struct
%       CAST    Castagne and Vappalle data struct
%       COX     COX used for Dit
%       CORTYPE LC or osc are only valid values
%       CORIND  load correction index used (1 for osc)
%       PC      physical constants
%
% Copyright (C) 2013 Alex J. Grede
% GPL v3, See LICENSE.txt for details
% This function is part of SAMIS (https://github.com/agrede/SAMIS)

A = Meas.A*1e4;
f = Meas.f(1,:);
V = Meas.V(:,1);

csvwrite(strcat(path,'rawCV.csv'),[[NaN;V] [f;Meas.C./A]]);
csvwrite(strcat(path,'rawGV.csv'),[[NaN;V] [f;Meas.G./A]]);

if (isa(corTyp,'char'))
  csvwrite(strcat(path,'corCV.csv'),[[NaN;V] [f;Meas.Cor.(corTyp).C(:,:,corInd)./A]]);
  csvwrite(strcat(path,'corGV.csv'),[[NaN;V] [f;Meas.Cor.(corTyp).G(:,:,corInd)./A]]);
endif

n1 = nan(length(V),1);
termDit = n1;
termPsi = n1;
nicolDit = n1;
castDit = n1;
simdta = NaN;
VFB = NaN;

if (isa(Term,'struct'))
   termDit = Term.Dit;
   termPsi = Term.psis;
   VFB = Term.VFB;
endif
if (isa(Nicol,'struct'))
  nicolDit = Nicol.Dit;
  csvwrite(strcat(path,'Gpomega.csv'),[[NaN;V] [f;Nicol.Gpomega./PC.e.*2.5e-4]]);
endif
if (isa(Cast,'struct'))
  castDit = Cast.Dit;
endif
if (isa(Sim,'struct'))
  [Cgb,VG] = cgbVgb(Sim,Cox,0);
  csvwrite(strcat(path,'sim.csv'),[Sim.eta,Sim.psis,VG,
                                   [Sim.n,sum(Sim.n,2),
                                    Sim.p,sum(Sim.p,2)].*1e-6,
                                   Sim.Qc.*1e-4,sim.Cc.*1e-4,Cgb.*1e-4]);
  simdta = [Sim.Eg./PC.e;Sim.delta_so./PC.e;
            Sim.me./PC.me;Sim.mh./PC.me;Sim.kappas];
endif

csvwrite(strcat(path,'DIT.csv'),[V termPsi, [termDit castDit nicolDit].*PC.e.*1e-4]);

csvwrite(strcat(path,'Values.csv'),[A;Cox.*1e-4;VFB;simdta]);

endfunction
