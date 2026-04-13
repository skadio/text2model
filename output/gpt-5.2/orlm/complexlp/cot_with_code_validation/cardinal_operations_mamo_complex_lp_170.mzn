% Facility location / transportation problem (embedded data)

% Parameters
int: M = 5; % distribution centers
int: N = 9; % stores

set of int: DC = 1..M;
set of int: ST = 1..N;

array[DC] of int: openCost = [151000, 192000, 114000, 171000, 160000];
array[DC] of int: cap      = [1825,   1821,   1365,   1929,   1502];

array[ST] of int: demand = [739, 491, 550, 628, 606, 613, 512, 442, 480];

% Transportation cost per unit from distribution center i to store j
array[DC, ST] of int: transCost = array2d(DC, ST, [
  5, 2, 3, 8, 7, 4, 5, 6, 5,
  2, 4, 6, 3, 5, 7, 4, 2, 5,
  6, 7, 4, 2, 3, 5, 8, 6, 4,
  4, 3, 5, 6, 2, 4, 3, 5, 7,
  7, 6, 2, 5, 4, 3, 6, 4, 2
]);

int: totalDemand = sum(j in ST)(demand[j]);
int: maxCostPerUnit = max(i in DC, j in ST)(transCost[i,j]);
int: maxTotalCost = sum(i in DC)(openCost[i]) + totalDemand * maxCostPerUnit;

% Decision Variables
array[DC] of var bool: open;
array[DC, ST] of var 0..totalDemand: ship;

var 0..maxTotalCost: totalCost;

% Constraints: meet all store demands exactly
constraint forall(j in ST) (
  sum(i in DC)(ship[i,j]) = demand[j]
);

% Constraints: ship only from open DCs and within capacity
constraint forall(i in DC) (
  sum(j in ST)(ship[i,j]) <= cap[i] * bool2int(open[i])
);

% Objective: opening + transportation
constraint totalCost =
  sum(i in DC)(openCost[i] * bool2int(open[i])) +
  sum(i in DC, j in ST)(transCost[i,j] * ship[i,j]);

solve minimize totalCost;

output [
  "totalCost = ", show(totalCost), "\n",
  "open = ", show(open), "\n",
  "ship =\n",
  concat([ concat([ show(ship[i,j]) ++ if j == N then "\n" else "\t" endif
                  | j in ST ])
         | i in DC ])
];