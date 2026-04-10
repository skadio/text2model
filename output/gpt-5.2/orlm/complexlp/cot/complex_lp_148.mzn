% Parameters (with values embedded)
int: M = 9; % potential distribution centers
int: N = 7; % retail stores

set of int: DC = 1..M;
set of int: ST = 1..N;

array[DC] of int: openCost = [151000, 192000, 114000, 171000, 160000, 120000, 182000, 186000, 174000];

array[ST] of int: demand = [695, 737, 452, 616, 587, 779, 892];

array[DC] of int: capacity = [1864, 1980, 814, 864, 1320, 1952, 1447, 1886, 1962];

% Transportation cost per unit from DC i to store j
% NOTE: The problem statement does not provide the full 9x7 matrix ("etc."), so we embed a consistent placeholder matrix.
% Replace with the true costs if available.
array[DC, ST] of int: transCost =
[
| 3, 5, 7, 6, 4, 8, 9 |
| 2, 4, 6, 5, 3, 7, 8 |
| 4, 6, 5, 7, 6, 4, 5 |
| 5, 3, 4, 6, 7, 5, 6 |
| 6, 5, 3, 4, 5, 6, 7 |
| 3, 4, 5, 3, 4, 5, 6 |
| 7, 6, 5, 4, 3, 2, 4 |
| 5, 7, 6, 5, 4, 3, 2 |
| 4, 5, 6, 7, 5, 4, 3 |
];

int: totalDemand = sum(j in ST)(demand[j]);
int: maxCap = max(i in DC)(capacity[i]);

% Variables
array[DC] of var 0..1: open;                     % 1 if distribution center i is opened
array[DC, ST] of var 0..totalDemand: ship;       % units shipped from DC i to store j

% Constraints
constraint
  forall(j in ST)(
    sum(i in DC)(ship[i,j]) = demand[j]
  );

constraint
  forall(i in DC)(
    sum(j in ST)(ship[i,j]) <= capacity[i] * open[i]
  );

% Objective
var int: totalCost =
  sum(i in DC)(openCost[i] * open[i]) +
  sum(i in DC, j in ST)(transCost[i,j] * ship[i,j]);

solve minimize totalCost;