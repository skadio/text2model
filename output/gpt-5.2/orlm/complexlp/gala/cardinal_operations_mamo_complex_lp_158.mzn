include "globals.mzn";

% Facility location / capacitated distribution planning (8 centers, 8 stores)
int: C = 8; % centers
int: S = 8; % stores

set of int: Centers = 1..C;
set of int: Stores  = 1..S;

array[Centers] of int: openCost = [151000, 192000, 114000, 171000, 160000, 120000, 182000, 186000];

array[Centers, Stores] of int: shipCost =
  [| 3, 3, 5, 4, 3, 5, 2, 4
   | 2, 4, 5, 1, 4, 2, 5, 4
   | 1, 1, 3, 3, 2, 4, 4, 3
   | 4, 4, 1, 3, 5, 3, 5, 1
   | 2, 4, 1, 4, 2, 2, 1, 2
   | 5, 2, 4, 4, 4, 4, 5, 3
   | 1, 4, 2, 4, 2, 2, 4, 5
   | 2, 2, 4, 2, 2, 4, 4, 1 |];

array[Stores] of int: demand = [695, 737, 452, 616, 587, 779, 892, 440];
array[Centers] of int: capacity = [1980, 814, 864, 1320, 1952, 1447, 1886, 1962];

int: totalDemand = sum(s in Stores)(demand[s]);
int: maxShip = totalDemand;

% Decision variables
array[Centers] of var 0..1: open;                         % 1 if center is opened
array[Centers, Stores] of var 0..maxShip: ship;           % units shipped center c -> store s

% Demand satisfaction (each store fully met)
constraint forall(s in Stores)(
  sum(c in Centers)(ship[c,s]) = demand[s]
);

% Capacity limits (only if open)
constraint forall(c in Centers)(
  sum(s in Stores)(ship[c,s]) <= capacity[c] * open[c]
);

% Objective
var int: totalOpenCost = sum(c in Centers)(openCost[c] * open[c]);
var int: totalShipCost = sum(c in Centers, s in Stores)(shipCost[c,s] * ship[c,s]);
var int: totalCost = totalOpenCost + totalShipCost;

solve minimize totalCost;

output [
  "TotalCost = ", show(totalCost), "\n",
  "OpenCost  = ", show(totalOpenCost), "\n",
  "ShipCost  = ", show(totalShipCost), "\n",
  "Open      = ", show(open), "\n",
  "Ship matrix (centers x stores) =\n", show(ship), "\n"
];