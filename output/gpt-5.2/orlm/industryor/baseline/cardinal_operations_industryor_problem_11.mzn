% Red Star Plastics Factory - Production planning with substitution (larger volume can satisfy smaller demand)
% Data embedded directly in the model.

include "globals.mzn";

int: n = 6;
set of int: T = 1..n;

array[T] of int: volume = [1500, 2500, 4000, 6000, 9000, 12000];
array[T] of int: demand = [500, 550, 700, 900, 400, 300];
array[T] of int: varCost = [5, 8, 10, 12, 16, 18];

int: setupCost = 1200;

% x[i,j] = number of units of type i used to satisfy demand of type j
% Feasible only if i has volume >= j (i >= j due to sorted volumes)
array[T, T] of var 0..sum(demand): x;

% Produce[i] = total units produced of type i
array[T] of var 0..sum(demand): produce;

% Activate equipment if produce[i] > 0
array[T] of var bool: active;

% Disallow infeasible substitutions (smaller volume cannot satisfy larger demand)
constraint
  forall(i in T, j in T where i < j) ( x[i,j] = 0 );

% Meet each demand exactly (can be met by its type or any larger type)
constraint
  forall(j in T) ( sum(i in T)(x[i,j]) = demand[j] );

% Production balance: all produced units are allocated to some demand
constraint
  forall(i in T) ( produce[i] = sum(j in T)(x[i,j]) );

% Activation linking
constraint
  forall(i in T) (
    active[i] <-> (produce[i] > 0)
  );

% Objective: variable production costs + fixed setup costs for activated equipment
var int: totalCost =
  sum(i in T)( varCost[i] * produce[i] + setupCost * bool2int(active[i]) );

solve minimize totalCost;

output [
  "Total cost (Yuan): ", show(totalCost), "\n\n",
  "Production by type:\n"
] ++
[
  "  Type ", show(i), " (Vol ", show(volume[i]), "): ",
  show(produce[i]), "  Active=", show(active[i]), "\n"
  | i in T
] ++
[
  "\nAllocation matrix x[i,j] (produced type i used for demand j):\n"
] ++
[
  if j = 1 then "" else "" endif
  | j in 1..0
] ++
[
  "Demand type j=" ++ show(j) ++ " (Vol " ++ show(volume[j]) ++ ", Dem " ++ show(demand[j]) ++ "): " ++
  concat([ if x[i,j] > 0 then "i" ++ show(i) ++ ":" ++ show(x[i,j]) ++ " " else "" endif | i in T ]) ++ "\n"
  | j in T
];