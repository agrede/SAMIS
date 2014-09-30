function Semi = semiProps(Props,T,Param,PC)
% SEMIPROPS returns the parameters  for a
%
% Copyright (C) 2013--2014 Alex J. Grede
% GPL v3, See LICENSE.txt for details
% This function is part of SAMIS (https://github.com/agrede/SAMIS)
Semi = struct;

if (length(Props.groupB)<1)
% Group IV assumed
  % Only assuming one group A for now
  mat = Props.groupA{1};
  A = moscParam(Param.(Props.crystalStructure).(mat),T,PC);
  Semi.me = A.me;
  Semi.mh = A.mh;
  Semi.Eg = A.Eg;
  Semi.delta_so = A.delta_so;
  Semi.kappas = A.kappas;
  Semi.VBO = A.VBO;
  Semi.Impurities = A.Impurities;
elseif (length(Props.groupA)+length(Props.groupB)<3)
  % Binary Assumed
  mat = strcat(Props.groupA{1},Props.groupB{1});
  A = moscParam(Param.(Props.crystalStructure).(mat),T,PC);
  Semi.me = A.me;
  Semi.mh = A.mh;
  Semi.Eg = A.Eg;
  Semi.delta_so = A.delta_so;
  Semi.kappas = A.kappas;
  Semi.VBO = A.VBO;
  Semi.Impurities = A.Impurities;
else
  % Combination of ternaries (only can do up to quaternary?)
  [mats, weights] = ternaryPermitations(Props.groupA,Props.groupB,...
                                        Props.weightsA,Props.weightsB);
  Semi.mats = mats;
  Semi.weights = weights;
  % Initialize Variables
  Semi.me = [0;0;0];
  Semi.mh = [0;0;0];
  Semi.Eg = [0;0;0];
  Semi.delta_so = 0;
  Semi.kappas = 0;
  Semi.VBO = 0;
  Semi.Impurities = struct;
  Semi.Impurities.Acceptors = struct;
  Semi.Impurities.Donors = struct;

  % Add weighted combinations
  for k=1:size(mats,2)
    A = moscParam(Param.(Props.crystalStructure).(mats{1,k}),T,PC);
    B = moscParam(Param.(Props.crystalStructure).(mats{2,k}),T,PC);
    C = struct;

    if (isfield(Param.(strcat('Bow_',Props.crystalStructure)),mats{3,k}))
      C = Param.(strcat('Bow_',Props.crystalStructure)).(mats{3,k});
      C.Eg = C.E_g+weights(2,k).*C.E_g_1;
      C.kappas = C.kappa;
      C.me = [C.meffe;C.meffDOS];
      C.mh = [C.meffhh;C.mefflh;C.meffso];
    else
      C.Eg = 0;
      C.me = 0;
      C.mh = 0;
      C.kappas = 0;
      C.delta_so = 0;
      C.VBO = 0;
    endif
    iType = {'Donors','Acceptors'};
    for k2 = 1:2
      impElmts = unique([fieldnames(A.Impurities.(iType{k2}));...
                                   fieldnames(B.Impurities.(iType{k2}))]);
      for k3 = 1:length(impElmts)
        if (~isfield(Semi.Impurities.(iType{k2}),impElmts{k3}))
          Semi.Impurities.(iType{k2}).(impElmts{k3}) = 0;
        endif

        if (isfield(A.Impurities.(iType{k2}),impElmts{k3}))
          a = A.Impurities.(iType{k2}).(impElmts{k3});
        else
          a = B.Impurities.(iType{k2}).(impElmts{k3});
        endif

        if (isfield(B.Impurities.(iType{k2}),impElmts{k3}))
          b = B.Impurities.(iType{k2}).(impElmts{k3});
        else
          b = A.Impurities.(iType{k2}).(impElmts{k3});
        endif
        if (isfield(C,'Impurities'))
          if (isfield(C.Impurities.(iType{k2}),impElmts{k3}))
            c = C.Impurities.(iType{k2}).(impElmts{k3});
          else
            c = 0;
          endif
        else
          c = 0;
        endif

        Semi.Impurities.(iType{k2}).(impElmts{k3}) =...
             Semi.Impurities.(iType{k2}).(impElmts{k3})...
             +weights(3,k).*bowing(a,b,c,weights(:,k));
      endfor
    endfor
    Semi.me = Semi.me + weights(3,k).*bowing(A.me,B.me,C.me,weights(:,k));
    Semi.Eg = Semi.Eg + weights(3,k).*bowing(A.Eg,B.Eg,C.Eg,weights(:,k));
    Semi.kappas = Semi.kappas + weights(3,k).*bowing(A.kappas,B.kappas,...
                                                   C.kappas,weights(:,k));
    Semi.mh = Semi.mh +weights(3,k).*bowing(A.mh,B.mh,C.mh,weights(:,k));
    Semi.delta_so = Semi.delta_so +weights(3,k).*bowing(A.delta_so,...
                                                      B.delta_so,...
                                                      C.delta_so,...
                                                      weights(:,k));
    Semi.VBO = Semi.VBO + weights(3,k).*bowing(A.VBO,B.VBO,C.VBO,weights(:,k));
  endfor
  % Divide by sum of weights
  Semi.me = Semi.me./sum(weights(3,:));
  Semi.mh = Semi.mh./sum(weights(3,:));
  Semi.Eg = Semi.Eg./sum(weights(3,:));
  Semi.kappas = Semi.kappas./sum(weights(3,:));
  Semi.delta_so = Semi.delta_so./sum(weights(3,:));
  Semi.VBO = Semi.VBO./sum(weights(3,:));
  for k2 = 1:2
    impElmts = fieldnames(Semi.Impurities.(iType{k2}));
    for k3 = 1:length(impElmts)
      Semi.Impurities.(iType{k2}).(impElmts{k3}) = ...
          Semi.Impurities.(iType{k2}).(impElmts{k3})./sum(weights(3,:));
    endfor
  endfor
endif
endfunction
