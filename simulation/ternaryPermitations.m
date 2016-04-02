function [perm,weights] = ternaryPermitations(A,B,wA,wB)
% TERNARYPERMITATIONS calculates the number of permitations and weights
%       given Group A and Group B elements
%
%       PERM    3xN matrix with N being number of permitations
%               example 2 A groups: ["A1B1";"A2B1";"A1A2B1"]
%               example 2 B groups: ["A1B1";"A1B2";"A1B1B2"]
%       WEIGHTS 3xN matrix with N being numer of permitations
%               example 2 A groups: [wA(1);wA(2);wA(1)*wA(2)*wB(1)]
%               example 2 B groups: [wB(1);wB(2);wA(1)*wB(1)*wB(2)]
%
%       [PERM,WEIGHTS] = TERNARYPERMITATIONS(A,B)
%               A       cell array of group A elements (ex: {"Ga","In"})
%               B       cell array of group B elements (ex: {"As","P"})
%               Must be in alphabetical order for other functions to work
%       [PERM,WEIGHTS] = TERNARYPERMITATIONS(A,B,wA,wB)
%               wA      vector of group A weights (ex: [0.8,0.2]) default ones
%               wB      vector of group B weights (ex: [0.3,0.7]) default ones
%
% Copyright (C) 2013--2016 Alex J. Grede
% GPL v3, See LICENSE.txt for details
% This function is part of SAMIS (https://github.com/agrede/SAMIS)

if (nargin < 3)
   wA = ones(1,length(A));
   wB = ones(1,length(B));
endif

% Initialize with proper sizes
perm = cell(3,1/2*(length(A)+length(B)-2)*length(A)*length(B));
weights = zeros(3,length(perm));

ind = 1;        % Current permitation index

% Type AAB Ternary -------------------------------------------------------------
for k1=1:length(A)
    for k2=k1+1:length(A)
        for k3=1:length(B)
            perm{1,ind} = strcat(A{k1},B{k3});
            perm{2,ind} = strcat(A{k2},B{k3});
            perm{3,ind} = strcat(A{[k1,k2]},B{k3});
            weights(:,ind) = [reshape(wA([k1,k2]),[],1);...
                              prod([wA([k1,k2]),wB(k3)])];
            ind = ind+1;
        endfor
    endfor
endfor

% Type ABB Ternary -------------------------------------------------------------
for k1=1:length(B)
    for k2=k1+1:length(B)
        for k3=1:length(A)
            perm{1,ind} = strcat(A{k3},B{k1});
            perm{2,ind} = strcat(A{k3},B{k2});
            perm{3,ind} = strcat(A{k3},B{[k1,k2]});
            weights(:,ind) = [reshape(wB([k1,k2]),[],1);...
                              prod([wA(k3),wB([k1,k2])])];
            ind= ind+1;
        endfor
    endfor
endfor
endfunction
