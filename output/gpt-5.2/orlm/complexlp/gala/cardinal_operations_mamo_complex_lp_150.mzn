% Facility location / capacitated distribution planning
% Data is embedded as requested.

include "globals.mzn";

int: F = 7;   % distribution centers
int: S = 9;   % stores

set of int: Facilities = 1..F;
set of int: Stores = 1..S;

% Opening cost per facility
array[Facilities] of int: openCost =
  [151000, 192000, 114000, 171000, 160000, 120000, 182000];

% NOTE:
% The problem statement mentions transport costs per unit (1..5), store demands (440..892),
% and facility capacities (814..1962), but it does not provide the actual 7x9 cost matrix,
% the 9 demand values, nor the 7 capacity values. A unique numeric optimum cannot be computed
% without those missing data.
%
% To keep this model runnable, we include placeholder data consistent with the stated ranges.
% Replace these with the actual instance data if available.

% Transport cost per unit from facility f to store s (range 1..5)
array[Facilities, Stores] of int: unitCost =
  [| 3, 4, 2, 5, 1, 3, 4, 2, 5
   | 2, 3, 4, 2, 5, 1, 3, 4, 2
   | 5, 1, 3, 4, 2, 5, 1, 3, 4
   | 4, 2, 5, 1, 3, 4, 2, 5, 1
   | 1, 5, 2, 3, 4, 2, 5, 1, 3
   | 3, 4, 1, 5, 2, 3, 4, 2, 5
   | 2, 3, 4, 1, 5, 2, 3, 4, 1 |];

% Demand per store (range 440..892)
array[Stores] of int: demand = [440, 510, 620, 700, 892, 560, 480, 750, 680];

% Capacity per facility (range 814..1962)
array[Facilities] of int: capacity = [900, 1200, 814, 1500, 1100, 1962, 1000];

% Decision variables
array[Facilities] of var 0..1: open;                 % 1 if facility is opened
array[Facilities, Stores] of var 0..max(demand): ship; % units shipped from f to s

% Demand satisfaction: each store's demand must be met
constraint forall(s in Stores) (
  sum(f in Facilities)(ship[f,s]) = demand[s]
);

% Capacity: total shipped from facility <= capacity if opened, else 0
constraint forall(f in Facilities) (
  sum(s in Stores)(ship[f,s]) <= capacity[f] * open[f]
);

% Objective: opening + transport
var int: totalOpenCost = sum(f in Facilities)(openCost[f] * open[f]);
var int: totalTransCost = sum(f in Facilities, s in Stores)(unitCost[f,s] * ship[f,s]);
var int: totalCost = totalOpenCost + totalTransCost;

solve minimize totalCost;

output [
  "Opened facilities (0/1) = ", show(open), "\n",
  "Total opening cost = ", show(totalOpenCost), "\n",
  "Total transport cost = ", show(totalTransCost), "\n",
  "Total cost = ", show(totalCost), "\n",
  "Shipments (rows=facilities, cols=stores) =\n",
  concat([ concat([ show(ship[f,s]) ++ if s==S then "\n" else "\t" endif
                  | s in Stores ])
         | f in Facilities ])
];