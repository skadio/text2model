% Facility Location / Capacitated Distribution with fixed opening costs
% All data embedded as requested.

int: F = 5;  % potential distribution centers
int: S = 9;  % retail stores

set of int: FAC = 1..F;
set of int: STO = 1..S;

array[FAC] of int: openCost = [151000, 192000, 114000, 171000, 160000];

array[FAC, STO] of int: shipCost =
  [| 5,2,3,3,3,5,4,3,5
   | 2,4,2,4,5,1,4,2,5
   | 4,1,1,3,3,2,4,4,3
   | 4,4,1,3,5,3,5,1,2
   | 4,1,4,2,2,1,2,5,2 |];

array[STO] of int: demand = [739, 491, 766, 854, 827, 908, 434, 605, 480];

array[FAC] of int: capacity = [1825, 1821, 1365, 1929, 1502];

% Decision variables
array[FAC] of var 0..1: open;                      % 1 if center is opened
array[FAC, STO] of var 0..1: assign;               % 1 if store j supplied by center i

% Each store must be supplied by exactly one open center
constraint
  forall(j in STO) (
    sum(i in FAC) assign[i,j] = 1
  );

% Can only assign to an open center
constraint
  forall(i in FAC, j in STO) (
    assign[i,j] <= open[i]
  );

% Capacity constraints
constraint
  forall(i in FAC) (
    sum(j in STO) demand[j] * assign[i,j] <= capacity[i]
  );

% Objective: opening costs + transportation costs (cost per unit * units shipped)
var int: totalCost =
  sum(i in FAC) openCost[i] * open[i]
  + sum(i in FAC, j in STO) shipCost[i,j] * demand[j] * assign[i,j];

solve minimize totalCost;

output [
  "Optimal total cost = ", show(totalCost), "\n",
  "Open centers (1..", show(F), "): ", show([fix(open[i]) | i in FAC]), "\n",
  "Assignments (store -> center):\n"
] ++
[
  "  Store " ++ show(j) ++ " (demand " ++ show(demand[j]) ++ ") -> Center "
  ++ show( sum(i in FAC)( i * fix(assign[i,j]) ) ) ++ "\n"
  | j in STO
];