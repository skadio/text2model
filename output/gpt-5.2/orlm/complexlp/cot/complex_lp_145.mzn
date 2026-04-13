% Parameters (with values embedded)
int: M = 8; % distribution centers
int: N = 8; % retail stores

set of int: DC = 1..M;
set of int: ST = 1..N;

array[DC] of int: openCost = [151000, 192000, 114000, 171000, 160000, 120000, 182000, 186000];

% Transportation cost per unit from distribution center i to store j
array[DC, ST] of int: transpCost =
[
| 3, 5, 4, 5, 7, 6, 8, 4 |
| 2, 4, 3, 6, 5, 7, 6, 4 |
| 3, 6, 5, 4, 6, 5, 7, 3 |
| 4, 5, 6, 3, 4, 6, 5, 4 |
| 5, 4, 5, 4, 3, 5, 6, 5 |
| 4, 3, 4, 5, 4, 3, 5, 4 |
| 6, 5, 4, 6, 5, 4, 3, 6 |
| 5, 6, 3, 5, 6, 4, 5, 4 |
];

array[ST] of int: demand = [695, 802, 450, 620, 510, 725, 390, 440];

array[DC] of int: capacity = [1980, 2030, 1750, 1900, 1850, 2000, 1800, 1962];

int: totalDemand = sum(j in ST)(demand[j]);
int: maxCap = max(i in DC)(capacity[i]);
int: maxShip = max(totalDemand, maxCap);

% Variables
array[DC] of var 0..1: open;
array[DC, ST] of var 0..maxShip: ship;

% Constraints
constraint forall(j in ST)(
  sum(i in DC)(ship[i,j]) = demand[j]
);

constraint forall(i in DC)(
  sum(j in ST)(ship[i,j]) <= capacity[i] * open[i]
);

% Objective
var int: totalCost =
  sum(i in DC)(openCost[i] * open[i]) +
  sum(i in DC, j in ST)(transpCost[i,j] * ship[i,j]);

solve minimize totalCost;