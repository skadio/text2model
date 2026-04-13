include "globals.mzn";

% Parameters
int: n = 6;
set of int: CITIES = 1..n;

array[CITIES, CITIES] of int: cost =
  [| 0, 65, 41, 14, 16, 35
   | 65, 0, 76, 52, 89, 45
   | 41, 76, 0, 72, 38, 62
   | 14, 52, 72, 0, 22, 24
   | 16, 89, 38, 22, 0, 89
   | 35, 45, 62, 24, 89, 0 |];

int: U = sum(i in CITIES, j in CITIES where i != j)(cost[i,j]);

% Variables
array[CITIES] of var CITIES: succ;
array[CITIES] of var 0..n-1: u; % MTZ order variables
var 0..U: total_cost;

% Constraints
constraint forall(i in CITIES)(succ[i] != i);

% Hamiltonian cycle
constraint circuit(succ);

% MTZ subtour elimination (redundant with circuit but keeps structure)
constraint u[1] = 0;
constraint forall(i in 2..n)(u[i] >= 1 /\ u[i] <= n-1);
constraint forall(i in 2..n, j in 2..n where i != j)(
  u[i] - u[j] + (n-1) * bool2int(succ[i] == j) <= n-2
);

constraint total_cost = sum(i in CITIES)(cost[i, succ[i]]);

solve minimize total_cost;

output [
  "total_cost = ", show(total_cost), "\n",
  "succ = ", show(succ), "\n"
];