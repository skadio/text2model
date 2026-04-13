% Parameters (with values embedded)
int: n = 6;
set of int: CITIES = 1..n;

array[CITIES, CITIES] of int: cost =
[
|  0, 43, 39, 97, 84, 67 |
| 43,  0, 18, 92, 27, 51 |
| 39, 18,  0, 84, 60, 15 |
| 97, 92, 84,  0, 42, 32 |
| 84, 27, 60, 42,  0, 18 |
| 67, 51, 15, 32, 18,  0 |
];

% Variables
array[1..n] of var CITIES: succ;     % successor city in the tour
array[1..n] of var 0..n-1: u;        % MTZ ordering variables (subtour elimination)
var 0..10000: total_cost;

% Constraints
constraint circuit(succ);

% Fix symmetry: start at city 1 (does not change optimal cost, only removes rotations)
constraint succ[1] != 1;

% MTZ subtour elimination (redundant with circuit in many solvers, but keeps it explicit/robust)
constraint u[1] = 0;
constraint forall(i in 2..n)(u[i] >= 1 /\ u[i] <= n-1);
constraint forall(i in 2..n, j in 2..n where i != j)(
  u[i] - u[j] + n * (if succ[i] == j then 1 else 0 endif) <= n - 1
);

constraint total_cost = sum(i in CITIES)( cost[i, succ[i]] );

% Objective
solve minimize total_cost;

output [
  "Minimum total delivery cost = ", show(total_cost), "\n",
  "Successor representation (i -> succ[i]):\n",
  concat([ show(i) ++ " -> " ++ show(succ[i]) ++ "\n" | i in CITIES ])
];