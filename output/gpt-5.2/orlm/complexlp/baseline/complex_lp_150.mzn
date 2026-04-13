% Facility location / capacitated distribution problem
% Data embedded directly as requested.

int: F = 7;   % distribution centers
int: S = 9;   % retail stores

set of int: DC = 1..F;
set of int: ST = 1..S;

array[DC] of int: openCost = [
  151000, 192000, 114000, 171000, 160000, 120000, 182000
];

% Capacities (units) for each distribution center (814..1962)
array[DC] of int: cap = [
  1962, 1634, 1420, 1298, 1186,  972,  814
];

% Demands (units) for each store (440..892)
array[ST] of int: demand = [
  892, 840, 792, 748, 705, 662, 615, 520, 440
];

% Transportation costs per unit from each DC to each store (1..5)
array[DC, ST] of int: tcost = array2d(DC, ST, [
  2,3,4,5,3,2,1,4,5,
  3,2,5,4,2,3,4,1,5,
  4,3,2,3,5,4,2,5,1,
  5,4,3,2,4,5,3,2,4,
  2,5,4,3,2,1,5,4,3,
  1,2,3,4,5,4,3,2,1,
  3,1,2,5,4,3,2,5,4
]);

% Decision variables
array[DC] of var bool: open;
array[DC, ST] of var 0..max(demand): ship; % units shipped from DC to store

% Each store demand must be met exactly
constraint forall(j in ST) (
  sum(i in DC)(ship[i,j]) = demand[j]
);

% DC capacity respected if opened; else no shipments
constraint forall(i in DC) (
  sum(j in ST)(ship[i,j]) <= cap[i] * bool2int(open[i])
);

% Objective: opening + transportation
var int: totalCost =
  sum(i in DC)(openCost[i] * bool2int(open[i])) +
  sum(i in DC, j in ST)(tcost[i,j] * ship[i,j]);

solve minimize totalCost;

output [
  "Optimal total cost = ", show(totalCost), "\n",
  "Open DCs = ", show([i | i in DC where fix(open[i]) == true]), "\n",
  "Shipments (DC x Store):\n"
] ++
[
  "DC " ++ show(i) ++ ": " ++ show([ship[i,j] | j in ST]) ++ "\n"
  | i in DC
];