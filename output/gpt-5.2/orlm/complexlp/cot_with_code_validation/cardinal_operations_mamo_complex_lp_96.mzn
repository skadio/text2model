include "globals.mzn";

% Parameters
int: n = 6;
set of int: CITIES = 1..n;

array[CITIES, CITIES] of int: cost =
array2d(CITIES, CITIES, [
  0, 21, 43, 25, 38, 91,
  21, 0, 32, 25, 16, 14,
  43, 32, 0, 96, 71, 98,
  25, 25, 96, 0, 53, 22,
  38, 16, 71, 53, 0, 100,
  91, 14, 98, 22, 100, 0
]);

% Variables
array[CITIES] of var CITIES: succ;   % successor city in the tour
array[CITIES] of var CITIES: pred;   % predecessor city in the tour
array[CITIES] of var 1..n: pos;      % position of each city in the tour (MTZ)
var int: total_cost;

% Constraints: one Hamiltonian cycle
constraint all_different(succ);
constraint all_different(pred);

constraint forall(i in CITIES) (
  pred[succ[i]] = i /\
  succ[pred[i]] = i
);

% Subtour elimination (MTZ), fix city 1 as position 1
constraint pos[1] = 1;
constraint forall(i in 2..n)(pos[i] >= 2 /\ pos[i] <= n);

constraint forall(i, j in CITIES where i != j /\ i != 1 /\ j != 1) (
  pos[i] - pos[j] + n * (if succ[i] == j then 0 else 1 endif) <= n - 1
);

% Total cost
constraint total_cost = sum(i in CITIES)(cost[i, succ[i]]);

% Objective
solve minimize total_cost;

output [
  "total_cost = ", show(total_cost), "\n",
  "succ = ", show(succ), "\n"
];