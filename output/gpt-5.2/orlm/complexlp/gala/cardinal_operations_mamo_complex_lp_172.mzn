include "globals.mzn";

% Facility Location / Capacitated Distribution with fixed opening costs
% Data embedded directly as required.

int: F = 8;   % facilities (distribution centers)
int: S = 9;   % stores

set of int: FAC = 1..F;
set of int: STO = 1..S;

array[FAC] of int: openCost = [151000, 192000, 114000, 171000, 160000, 120000, 182000, 186000];

array[STO] of int: demand = [779, 892, 440, 556, 414, 464, 920, 743, 528];

array[FAC] of int: cap = [1447, 1886, 1962, 1392, 1191, 1218, 1088, 1178];

% Transportation cost per unit from facility f to store s
array[FAC, STO] of int: shipCost =
[
  % s1 s2 s3 s4 s5 s6 s7 s8 s9
  | 2, 3, 4, 5, 3, 2, 4, 5, 3  % f1
  | 1, 2, 3, 4, 2, 3, 5, 4, 3  % f2
  | 1, 3, 2, 4, 3, 2, 4, 3, 2  % f3
  | 2, 1, 3, 5, 4, 2, 3, 4, 5  % f4
  | 3, 2, 1, 4, 5, 3, 2, 5, 4  % f5
  | 2, 4, 3, 1, 2, 5, 4, 3, 2  % f6
  | 4, 3, 2, 5, 4, 3, 2, 4, 5  % f7
  | 1, 2, 4, 3, 5, 2, 3, 4, 1  % f8
];

% Decision variables
array[FAC] of var 0..1: open;                 % 1 if facility is opened
array[FAC, STO] of var 0..max(demand): x;     % units shipped from facility f to store s

% Demand satisfaction: each store demand must be met exactly
constraint forall(s in STO) (
  sum(f in FAC)(x[f,s]) = demand[s]
);

% Capacity: total shipped from each facility cannot exceed capacity if opened
constraint forall(f in FAC) (
  sum(s in STO)(x[f,s]) <= cap[f] * open[f]
);

% Objective: opening cost + transportation cost
var int: totalOpenCost = sum(f in FAC)(openCost[f] * open[f]);
var int: totalShipCost = sum(f in FAC, s in STO)(shipCost[f,s] * x[f,s]);
var int: totalCost = totalOpenCost + totalShipCost;

solve minimize totalCost;

output [
  "Total cost = ", show(totalCost), "\n",
  "  Opening cost = ", show(totalOpenCost), "\n",
  "  Shipping cost = ", show(totalShipCost), "\n\n",
  "Open facilities (1=open): ", show(open), "\n\n",
  "Shipments x[f,s] (rows=facilities, cols=stores):\n",
  concat([ concat([ show(x[f,s]) ++ if s==S then "\n" else "\t" endif
                   | s in STO ])
           | f in FAC ])
];