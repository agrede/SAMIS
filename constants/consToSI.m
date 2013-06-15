function PSI = consToSI(P,PC)
% CONSTOSI Restructures file to SI units and different form
%   P = Structure from parameter file
%   PC = Physical Constants
%
% Copywrite (C) 2013 Alex J. Grede
% GPL v3, See LICENSE.txt for details
% This function is part of SAMIS (https://github.com/agrede/SAMIS)

FMT = loadjson('format.json');
psi = struct;
psi.ranges = struct;

fmts = fieldnames(FMT);

for n=1:length(fmts)
    if ((~strcmp(fmts{n},'preamble'))*isfield(P,fmts{n}))
       [tmp1,tmp2,tmp3,tmp4,tmp5] = regexp(fmts{n},'Bow_(.*)$');
       if (~isempty(tmp5))
         bowing = 1;
         parFmtName = tmp5{1}{1};

         if (isfield(FMT,parFmtName))
           parFmts = fieldnames(FMT.(parFmtName));
           for m = 1:length(parFmts)
             if (~isfield(FMT.(fmts{n}),parFmts{m}))
               FMT.(fmts{n}).(parFmts{m}) = FMT.(parFmtName).(parFmts{m});
             endif
           endfor
         endif
       else
         bowing = 0;
       endif

       PSI.(fmts{n}) = struct;
       PSI.Ranges.(fmts{n}) = struct;
       mats = fieldnames(P.(fmts{n}));

       for m=1:length(mats)
           [Values,Ranges] = consToSIField(P.(fmts{n}).(mats{m}),...
                                           FMT.(fmts{n}),...
                                           PC,...
                                           bowing);
           PSI.(fmts{n}).(mats{m}) = Values;
           PSI.Ranges.(fmts{n}).(mats{m}) = Ranges;
       endfor
    endif
endfor

endfunction
