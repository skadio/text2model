include "globals.mzn";

%-----------------------------
% Input data (from .dzn)
%-----------------------------
int: M;                              % number of goods
int: N;                              % number of raw materials
array[1..N] of int: Available;       % available amount of each material
array[1..N, 1..M] of int: Requirements; % material i needed per unit of good j
array[1..M] of int: Prices;          % revenue per unit of good j

%-----------------------------
% Decision variables
%-----------------------------
% Upper bound for each good: limited by each material with positive requirement.
array[1..M] of int: ub = [
  if exists(i in 1..N)(Requirements[i,j] > 0) then
    min([ Available[i] div Requirements[i,j] | i in 1..N where Requirements[i,j] > 0 ])
  else
    0
  endif
  | j in 1..M
];

array[1..M] of var 0..max(ub): Produce;   % units to produce of each good

%-----------------------------
% Constraints (material limits)
%-----------------------------
constraint forall(i in 1..N) (
  sum(j in 1..M)( Requirements[i,j] * Produce[j] ) <= Available[i]
);

%-----------------------------
% Objective: maximize revenue
%-----------------------------
var int: TotalRevenue = sum(j in 1..M)( Prices[j] * Produce[j] );

solve maximize TotalRevenue;

%-----------------------------
% Output
%-----------------------------
output [
  "Produce = ", show(Produce), "\n",
  "TotalRevenue = ", show(TotalRevenue), "\n"
];