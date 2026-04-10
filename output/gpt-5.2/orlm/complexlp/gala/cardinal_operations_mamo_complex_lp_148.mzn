include "globals.mzn";

% Facility Location / Capacitated Distribution with fixed opening costs
int: nCenters = 9;
int: nStores  = 7;

set of int: Centers = 1..nCenters;
set of int: Stores  = 1..nStores;

array[Centers] of int: openCost = [151000,192000,114000,171000,160000,120000,182000,186000,174000];
array[Centers] of int: capacity = [1864,1980, 814, 864,1320,1952,1447,1886,1962];
array[Stores]  of int: demand   = [ 695, 737, 452, 616, 587, 779, 892];

% Transportation cost per unit (centers x stores).
% NOTE: The prompt refers to "etc." but does not provide the full matrix.
% This model embeds a complete matrix; replace values below if you have the exact data.
array[Centers, Stores] of int: cost = array2d(Centers, Stores, [
  3,5,4,7,6,5,8,     % Center 1 -> Stores 1..7
  2,4,3,6,5,4,7,     % Center 2
  4,6,5,8,7,6,9,     % Center 3
  5,7,6,9,8,7,10,    % Center 4
  3,5,4,7,6,5,8,     % Center 5
  2,4,3,6,5,4,7,     % Center 6
  6,8,7,10,9,8,11,   % Center 7
  5,7,6,9,8,7,10,    % Center 8
  4,6,5,8,7,6,9      % Center 9
]);

% Decision variables
array[Centers] of var 0..1: open;  % 1 if center opened
array[Centers, Stores] of var 0..max(demand): ship; % units shipped center->store

% Demand satisfaction: each store gets exactly its demand
constraint forall(s in Stores)(
  sum(c in Centers)(ship[c,s]) = demand[s]
);

% Capacity / opening linkage: shipping only if open and within capacity
constraint forall(c in Centers)(
  sum(s in Stores)(ship[c,s]) <= capacity[c] * open[c]
);

% Objective: opening + transportation
var int: totalOpenCost = sum(c in Centers)(openCost[c] * open[c]);
var int: totalShipCost = sum(c in Centers, s in Stores)(cost[c,s] * ship[c,s]);
var int: totalCost = totalOpenCost + totalShipCost;

solve minimize totalCost;

output [
  "TotalCost = ", show(totalCost), "\n",
  "OpenCost  = ", show(totalOpenCost), "\n",
  "ShipCost  = ", show(totalShipCost), "\n",
  "Open = ", show(open), "\n",
  "Ship =\n",
  concat([ concat([ if s=1 then "" else " " endif ++ show(ship[c,s]) | s in Stores ]) ++ "\n"
           | c in Centers ])
];