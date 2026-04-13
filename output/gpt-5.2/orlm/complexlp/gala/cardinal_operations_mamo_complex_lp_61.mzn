include "globals.mzn";

% Cities: 1=E, 2=F, 3=G, 4=H
int: n = 4;
set of int: CITIES = 1..n;

% Symmetric travel costs (i -> j)
array[CITIES, CITIES] of int: cost =
  [| 0, 17, 52, 79
   | 17, 0, 15, 71
   | 52, 15, 0, 54
   | 79, 71, 54, 0 |];

% Successor representation of a Hamiltonian cycle:
% tour[i] = next city visited after i
array[CITIES] of var CITIES: tour;

% Each city has exactly one outgoing arc and one incoming arc
constraint all_different(tour);

% No self-loops
constraint forall(i in CITIES)(tour[i] != i);

% Enforce a single cycle visiting all cities (MTZ constraints)
array[CITIES] of var 1..n: u;
constraint u[1] = 1;
constraint forall(i in 2..n)(u[i] >= 2);

constraint forall(i in CITIES, j in 2..n where i != j)(
  (tour[i] = j) -> (u[i] + 1 = u[j])
);

% Objective: total cost of the tour
var int: total_cost = sum(i in CITIES)(cost[i, tour[i]]);

solve minimize total_cost;

output [
  "total_cost = ", show(total_cost), "\n",
  "tour (successor; 1=E,2=F,3=G,4=H) = ", show(tour), "\n"
];