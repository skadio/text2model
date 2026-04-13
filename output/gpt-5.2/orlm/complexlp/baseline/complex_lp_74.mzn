% Traveling Salesperson Problem (4 cities), minimize total tour cost.
% Data embedded directly.

int: n = 4;
set of int: CITIES = 1..n;

array[CITIES, CITIES] of int: cost =
[
  % to:  1   2   3   4
        0, 29, 97, 72,  % from 1
       29,  0, 69, 52,  % from 2
       97, 69,  0, 91,  % from 3
       72, 52, 91,  0   % from 4
];

% Successor representation of a Hamiltonian cycle:
% succ[i] = the city visited immediately after i.
array[CITIES] of var CITIES: succ;

include "alldifferent.mzn";
constraint alldifferent(succ);

% No self-loops
constraint forall(i in CITIES)(succ[i] != i);

% Ensure a single cycle visiting all cities (subtour elimination)
% Using MTZ-style ordering
array[CITIES] of var 1..n: ord;
constraint ord[1] = 1;
constraint forall(i in 2..n)(ord[i] >= 2);

constraint forall(i in CITIES, j in CITIES where i != j) (
  (succ[i] = j) -> (ord[j] = ((ord[i] mod n) + 1))
);

var int: total_cost = sum(i in CITIES)(cost[i, succ[i]]);

solve minimize total_cost;

output [
  "Minimum total travel cost = ", show(total_cost), "\n",
  "Successor mapping (city -> next city):\n",
  concat([ show(i) ++ " -> " ++ show(succ[i]) ++ "\n" | i in CITIES ])
];