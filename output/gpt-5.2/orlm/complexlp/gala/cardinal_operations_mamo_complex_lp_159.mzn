include "globals.mzn";

% Facility location / transportation with capacities (fixed-charge)
% Data embedded as requested.

int: F = 9; % potential distribution centers
int: S = 9; % stores

set of int: Centers = 1..F;
set of int: Stores  = 1..S;

array[Centers] of int: openCost = [
  151000, 192000, 114000, 171000, 160000, 120000, 182000, 186000, 174000
];

array[Stores] of int: demand = [
  871, 462, 538, 898, 992, 791, 818, 688, 778
];

% Capacities were described but not numerically listed; choose a consistent,
% explicit capacity vector within the stated range [840..1856].
array[Centers] of int: capacity = [
  1856, 1720, 1600, 1500, 1400, 1350, 1250, 1100,  900
];

% Transportation unit costs were described as 1..5 but not fully tabulated;
% embed a concrete 9x9 matrix within {1..5}.
array[Centers, Stores] of int: unitCost =
[
  % s1 s2 s3 s4 s5 s6 s7 s8 s9
    2, 4, 3, 5, 2, 1, 4, 3, 2,  % c1
    3, 2, 5, 4, 3, 2, 1, 5, 4,  % c2
    1, 3, 2, 4, 5, 3, 2, 1, 3,  % c3
    4, 5, 1, 3, 2, 4, 3, 2, 1,  % c4
    2, 1, 4, 2, 3, 5, 4, 3, 2,  % c5
    5, 2, 3, 1, 4, 2, 3, 4, 5,  % c6
    3, 4, 2, 5, 1, 3, 5, 2, 4,  % c7
    4, 3, 5, 2, 2, 4, 1, 5, 3,  % c8
    2, 5, 4, 3, 5, 1, 2, 3, 4   % c9
];

int: totalDemand = sum(i in Stores)(demand[i]);

% Decision variables
array[Centers] of var 0..1: open;
array[Centers, Stores] of var 0..totalDemand: ship;

% Demand satisfaction: each store fully supplied
constraint forall(s in Stores)(
  sum(c in Centers)(ship[c,s]) = demand[s]
);

% Capacity and linking to opening: if not open, no shipments; if open, within capacity
constraint forall(c in Centers)(
  sum(s in Stores)(ship[c,s]) <= capacity[c] * open[c]
);

% Objective: fixed opening + transportation
var int: totalOpenCost = sum(c in Centers)(openCost[c] * open[c]);
var int: totalTransCost = sum(c in Centers, s in Stores)(unitCost[c,s] * ship[c,s]);
var int: totalCost = totalOpenCost + totalTransCost;

solve minimize totalCost;

output [
  "TotalCost = ", show(totalCost), "\n",
  "OpenCost  = ", show(totalOpenCost), "\n",
  "TransCost = ", show(totalTransCost), "\n\n",
  "Open centers (1=open): ", show(open), "\n\n",
  "Shipments (rows=center, cols=store):\n",
  concat([ concat([ if s=1 then "" else " " endif ++ show(ship[c,s]) | s in Stores]) ++ "\n"
         | c in Centers ])
];