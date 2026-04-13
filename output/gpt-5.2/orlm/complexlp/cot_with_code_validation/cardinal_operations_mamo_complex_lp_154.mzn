% Facility location / transportation problem
int: M = 6; % distribution centers
int: N = 8; % retail stores

set of int: DC = 1..M;
set of int: ST = 1..N;

array[DC] of int: openCost = [151000, 192000, 114000, 171000, 160000, 120000];

array[DC, ST] of int: transCost = array2d(DC, ST, [
  2, 3, 1, 4, 3, 2, 4, 5,
  2, 4, 3, 2, 5, 4, 3, 2,
  5, 4, 2, 1, 3, 2, 5, 4,
  4, 3, 5, 2, 1, 4, 2, 3,
  5, 1, 4, 3, 2, 5, 3, 2,
  1, 2, 3, 4, 5, 1, 2, 4
]);

array[ST] of int: demand = [908, 434, 605, 480, 961, 787, 401, 789];
array[DC] of int: capacity = [1365, 1929, 1502, 1201, 1529, 961];

int: totalDemand = sum(j in ST)(demand[j]);
int: maxTransCost = max([transCost[i,j] | i in DC, j in ST]);
int: maxTotalCost = sum(i in DC)(openCost[i]) + totalDemand * maxTransCost;

% Decision variables
array[DC] of var bool: open;
array[DC, ST] of var 0..totalDemand: ship;

var 0..maxTotalCost: totalCost;

% Demand satisfaction
constraint forall(j in ST)(
  sum(i in DC)(ship[i,j]) = demand[j]
);

% Capacity only if opened
constraint forall(i in DC)(
  sum(j in ST)(ship[i,j]) <= capacity[i] * bool2int(open[i])
);

% Objective definition
constraint totalCost =
  sum(i in DC)(openCost[i] * bool2int(open[i])) +
  sum(i in DC, j in ST)(transCost[i,j] * ship[i,j]);

solve minimize totalCost;

output [
  "totalCost = ", show(totalCost), "\n",
  "open = ", show([bool2int(open[i]) | i in DC]), "\n"
];