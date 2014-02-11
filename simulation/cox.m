function C = cox(Stack,Param,PC)
%  COX returns the capactance density of a given stack
%       C = COX(STACK,PARAM,PC)
%               STACK   stack including a dielectric array
%                               contains either material or kappa parameter
%                               also contains thickness
%               PARAM   material parameter database
%               PC      physical constants
%
% Copyright (C) 2013 Alex J. Grede
% GPL v3, See LICENSE.txt for details
% This function is part of SAMIS (https://github.com/agrede/SAMIS)

invC = 0; % 1/C

% Loop through each dielectric layer in stack
for n = 1:length(Stack.dielectric)
    kappa = 1; % Default value
    if (isfield(Stack.dielectric{n},'kappa')) % User set dielectric
       kappa = Stack.dielectric{n}.kappa;
    elseif (isfield(Param.dielectrics,Stack.dielectric{n}.material)) % Mat set
       kappa = Param.dielectrics.(Stack.dielectric{n}.material).kappa;
    endif
    % Series capacitance addition
    invC += Stack.dielectric{n}.thickness./(PC.epsilon0.*kappa);
endfor

C = 1./invC;

endfunction
