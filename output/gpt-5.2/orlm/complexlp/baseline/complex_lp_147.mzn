% Facility Location + Transportation (Capacitated) - all data embedded

int: M = 8; % distribution centers
int: N = 9; % retail stores

set of int: Centers = 1..M;
set of int: Stores  = 1..N;

array[Centers] of int: openCost = [
  151000, 192000, 114000, 171000, 160000, 120000, 182000, 186000
];

array[Centers, Stores] of int: shipCost = array2d(Centers, Stores, [
  3,3,5,4,3,5,2,4,2,
  4,5,1,4,2,5,4,1,1,
  3,3,2,4,4,3,4,4,1,
  3,5,3,5,1,2,4,1,4,
  2,2,1,2,5,2,4,4,4,
  4,5,3,1,4,2,4,2,2,
  4,5,2,2,4,2,2,4,4,
  1,5,5,2,5,2,1,4,4
]);

array[Stores] of int: demand = [779, 892, 440, 556, 414, 464, 920, 743, 528];

array[Centers] of int: capacity = [1447, 1886, 1962, 1392, 1191, 1218, 1088, 1178];

int: totalDemand = sum(j in Stores)(demand[j]);

array[Centers] of var bool: open;

% x[i,j] = units shipped from center i to store j
array[Centers, Stores] of var 0..totalDemand: x;

% Demand satisfaction
constraint forall(j in Stores)(
  sum(i in Centers)(x[i,j]) = demand[j]
);

% Capacity and linking to opening decision
constraint forall(i in Centers)(
  sum(j in Stores)(x[i,j]) <= capacity[i] * bool2int(open[i])
);

% Objective: opening + transportation
var int: totalCost =
  sum(i in Centers)(openCost[i] * bool2int(open[i])) +
  sum(i in Centers, j in Stores)(shipCost[i,j] * x[i,j]);

solve minimize totalCost;

output [
  "Optimal total cost = ", show(totalCost), "\n",
  "Open centers: ", show([i | i in Centers where fix(open[i]) = true]), "\n"
];