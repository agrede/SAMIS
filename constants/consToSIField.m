function [Values,Ranges] = consToSIField(P,FMT,PC,bowing)
% CONSTOSIFIELD Uses format to set correct field values for material constants
%   Will fill in blanks with default values
%
%   [Values,Ranges] = CONSTOSIFIELD(P,FMT,PC)
%      Forces values for values and ranges as specified by format
%      Values are multipled by mult factor in format to do unit conversion
%      Ranges are set when P.field = [low, recomended, high] style
%   [Values,Ranges] = CONSTANTSIFIELD(P,FMT,PC,bowing)
%      If bowing is set default values have same matrix size but are 0
%
% Copyright (C) 2013--2014 Alex J. Grede
% GPL v3, See LICENSE.txt for details
% This function is part of SAMIS (https://github.com/agrede/SAMIS)

% Set optional Parameters
if (nargin < 4)
  bowing = 0;
endif

% Initalize
Values = struct;
Ranges = struct;

% Loop through field names specified in format
FN = fieldnames(FMT);
for n=1:length(FN)
  % Determine unit conversion multiplier ---------------------------------------
  mult = 1;
  if (ischar(FMT.(FN{n}).mult))         % For multiplication by phys constants
     mult = PC.(FMT.(FN{n}).mult);
  elseif (iscell(FMT.(FN{n}).mult))     % For mixed phys constants and numbers
    for k=1:length(FMT.(FN{n}).mult)
      if (ischar(FMT.(FN{n}).mult{k}))
        mult = mult.*PC.(FMT.(FN{n}).mult{k});
      else
        mult = mult.*FMT.(FN{n}).mult{k};
      endif
    endfor
  else                                  % For all other cases
    mult = prod(mult.*FMT.(FN{n}).mult);
  endif

  % Set parameter value with unit conversion multiplier ------------------------
  tmp = nan;                            % Init value
  if (isfield(P,FN{n}))                 % Parameter exists
     if (strcmp(FN{n},'Impurities'))    % Special Case
       Values.Impurities = struct;
       Ranges.Impurities = struct;
       if (isfield(P.(FN{n}),'Acceptors'))
         Values.Impurities.Acceptors = structfun(@(x) mult.*x,...
                                                 P.(FN{n}).Acceptors,...
                                                 'UniformOutput',false);
       else
         Values.Impurities.Acceptors = struct;
       endif
       if (isfield(P.(FN{n}),'Donors'))
         Values.Impurities.Donors = structfun(@(x) mult.*x,...
                                              P.(FN{n}).Donors,...
                                              'UniformOutput',false);
       else
         Values.Impurities.Donors = struct;
       endif
       Ranges.Impurities.Donors = nan;          % No support for ranges here
       Ranges.Impurities.Acceptors = nan;       % No support for ranges here
     else                               % Normal Case
       tmp = P.(FN{n}).*mult;
       if (bowing)
         tmp(logical(isnan(tmp))) = 0;
       endif
     end
  else                                  % Parameter does not exist
     if (bowing)
       tmp = zeros(size(FMT.(FN{n}).default));
     else
       tmp = FMT.(FN{n}).default;
     endif
  endif

  % Set parameter value and range ----------------------------------------------
  if (strcmp(FN{n},'Impurities'))
  elseif (size(tmp,2)==3)           % Param is defined in the [low, rec, high] style
    Values.(FN{n}) = tmp(:,2);
    Ranges.(FN{n}) = tmp(:,[1 3]);
  elseif (size(tmp,2)~=1)       % Paramter is of odd size (no range assumed)
    Values.(FN{n}) = tmp;
    Ranges.(FN{n}) = nan(size(tmp,1),size(tmp,2),2);
  else                          % No range specified only recomended
    Values.(FN{n}) = tmp;
    Ranges.(FN{n}) = nan(size(tmp,1),2);
  endif
endfor
endfunction
