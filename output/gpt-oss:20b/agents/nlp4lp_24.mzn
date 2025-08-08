include "globals.mzn";

%--------------------------------------------------------------------
% Data – to be supplied in a .dzn file
%--------------------------------------------------------------------
int: K;                               % number of worker categories
int: T;                               % number of years

array[1..K, 1..T] of int: Requirement;   % required manpower
array[1..K]          of int: Strength;     % initial workforce
array[1..K]          of int: RecruitLimit; % maximum recruitment each year
array[1..K]          of int: CostRedundancy;
array[1..K]          of int: CostOverman;
array[1..K]          of int: CostShort;
int: NumOverman;                      % global limit on excess full workers
int: NumShortwork;                    % global limit on short–term workers

%--------------------------------------------------------------------
% Decision variables
%--------------------------------------------------------------------
array[1..K, 1..T] of var int: W;                 % workforce at the end of each year
array[1..K, 1..T] of var 0..RecruitLimit[k]: Recruit;   % recruitment
array[1..K, 1..T] of var int: Redundancy;        % workers that leave
array[1..K, 1..T] of var int: Short;            % short–term workers
array[1..K, 1..T] of var int: SurplusFull;     % full workers above requirement

%--------------------------------------------------------------------
% Workforce dynamics
%--------------------------------------------------------------------
constraint forall(k in 1..K)(
    W[k,1] == Strength[k] + Recruit[k,1] - Redundancy[k,1]
);
constraint forall(k in 1..K, t in 2..T)(
    W[k,t] == W[k,t-1] + Recruit[k,t] - Redundancy[k,t]
);
constraint forall(k,t)(W[k,t] >= 0);          % workforce can’t be negative

%--------------------------------------------------------------------
% Requirement satisfaction (short workers provide 0.5 full equivalents)
%--------------------------------------------------------------------
constraint forall(k,t)(
    2 * W[k,t] + Short[k,t] >= 2 * Requirement[k,t]
);

%--------------------------------------------------------------------
% Surplus of full workers beyond requirement
%--------------------------------------------------------------------
constraint forall(k,t)(
    SurplusFull[k,t] = if W[k,t] - Requirement[k,t] >= 0 then
                           W[k,t] - Requirement[k,t]
                       else
                           0
                       endif
);

%--------------------------------------------------------------------
% Global limits
%--------------------------------------------------------------------
constraint sum(k in 1..K, t in 1..T)(SurplusFull[k,t]) <= NumOverman;
constraint sum(k in 1..K, t in 1..T)(Short[k,t])          <= NumShortwork;

%--------------------------------------------------------------------
% Objective – minimise total cost
%--------------------------------------------------------------------
var int: TotalCost = sum(k in 1..K, t in 1..T)(
    Redundancy[k,t] * CostRedundancy[k] +
    Short[k,t]     * CostShort[k]     +
    SurplusFull[k,t] * CostOverman[k]
);

solve minimize TotalCost;

%--------------------------------------------------------------------
% Output
%--------------------------------------------------------------------
output [
    "Total Cost = ", show(TotalCost), "\n",
    "\nYear-by-year workforce:\n",
    concat([ show(t) ++ ": "
             ++ concat([ show(k) ++ "=" ++ show(W[k,t]) ++ " "
                         | k in 1..K]) ++ "\n"
             | t in 1..T ])
];