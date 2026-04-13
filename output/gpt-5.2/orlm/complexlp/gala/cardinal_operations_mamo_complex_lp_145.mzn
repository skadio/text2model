include "globals.mzn";

% Capacitated Facility Location / Transportation with fixed opening costs
int: F = 8; % distribution centers
int: S = 8; % retail stores

set of int: FAC = 1..F;
set of int: STO = 1..S;

% ----- Data (embedded as requested) -----
array[FAC] of int: openCost = [
  151000, 192000, 114000, 171000, 160000, 120000, 182000, 186000
];

% Transportation cost per unit from facility f to store s.
% NOTE: The problem statement references a full 8x8 table ("and so on") but does not
% actually provide the complete matrix values. To make this model runnable,
% we embed a placeholder matrix that must be replaced by the true costs.
array[FAC, STO] of int: transCost = array2d(FAC, STO, [
  % s=1 2 3 4 5 6 7 8
     3,3,3,3,3,3,3,4,  % f=1
     2,2,2,2,2,2,2,4,  % f=2
     3,3,3,3,3,3,3,4,  % f=3
     3,3,3,3,3,3,3,4,  % f=4
     3,3,3,3,3,3,3,4,  % f=5
     3,3,3,3,3,3,3,4,  % f=6
     3,3,3,3,3,3,3,4,  % f=7
     3,3,3,3,3,3,3,4   % f=8
]);

% Store demands.
% NOTE: Only Store 1 (695) and Store 8 (440) are explicitly stated; the rest are not provided.
% To keep the model runnable, we embed a placeholder demand vector to be replaced with the true data.
array[STO] of int: demand = [695, 600, 550, 520, 500, 480, 460, 440];

% Facility capacities.
% NOTE: Only Facility 1 (1980) and Facility 8 (1962) are explicitly stated; the rest are not provided.
% To keep the model runnable, we embed a placeholder capacity vector to be replaced with the true data.
array[FAC] of int: cap = [1980, 2000, 1900, 2100, 2050, 1950, 2020, 1962];

% ----- Decision variables -----
array[FAC] of var 0..1: open;                         % 1 if facility opened
int: totalDemand = sum(s in STO)(demand[s]);
array[FAC, STO] of var 0..totalDemand: ship;          % units shipped from f to s

% ----- Constraints -----
% Meet each store's demand exactly
constraint forall(s in STO)(
  sum(f in FAC)(ship[f,s]) = demand[s]
);

% Do not exceed facility capacity; if closed, cannot ship
constraint forall(f in FAC)(
  sum(s in STO)(ship[f,s]) <= cap[f] * open[f]
);

% ----- Objective -----
var int: totalOpenCost = sum(f in FAC)(openCost[f] * open[f]);
var int: totalTransCost = sum(f in FAC, s in STO)(transCost[f,s] * ship[f,s]);
var int: totalCost = totalOpenCost + totalTransCost;

solve minimize totalCost;

output [
  "Open = ", show(open), "\n",
  "Ship = \n", show(ship), "\n",
  "TotalOpenCost = ", show(totalOpenCost), "\n",
  "TotalTransCost = ", show(totalTransCost), "\n",
  "TotalCost = ", show(totalCost), "\n"
];