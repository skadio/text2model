% Parameters (with values embedded)
int: M = 8; % potential distribution centers
int: N = 5; % retail stores

set of int: DC = 1..M;
set of int: ST = 1..N;

array[DC] of int: openCost = [151000, 192000, 114000, 171000, 160000, 120000, 182000, 186000];

array[DC, ST] of int: transCost =
[
| 3, 3, 5, 4, 3
| 5, 2, 4, 2, 4
| 5, 1, 4, 2, 5
| 4, 1, 1, 3, 3
| 2, 4, 4, 3, 4
| 4, 1, 3, 5, 3
| 5, 1, 2, 4, 1
| 4, 2, 2, 1, 2
];

array[ST] of int: demand = [964, 739, 491, 766, 854];

array[DC] of int: capacity = [1308, 1575, 834, 1005, 1904, 1825, 1821, 1365];

int: totalDemand = sum(j in ST)(demand[j]);

% Variables
array[DC] of var 0..1: open;
array[DC, ST] of var 0..totalDemand: ship;

% Constraints
% Demand must be met exactly
constraint
  forall(j in ST) (
    sum(i in DC)(ship[i,j]) = demand[j]
  );

% Shipments only from opened DCs and within capacity
constraint
  forall(i in DC) (
    sum(j in ST)(ship[i,j]) <= capacity[i] * open[i]
  );

% Objective
var int: totalOpenCost = sum(i in DC)(openCost[i] * open[i]);
var int: totalTransCost = sum(i in DC, j in ST)(transCost[i,j] * ship[i,j]);
var int: totalCost = totalOpenCost + totalTransCost;

solve minimize totalCost;

output [
  "Optimal total cost = ", show(totalCost), "\n",
  "Opening cost = ", show(totalOpenCost), "\n",
  "Transportation cost = ", show(totalTransCost), "\n",
  "Open DCs = ", show([ i | i in DC where fix(open[i]) = 1 ]), "\n"
];