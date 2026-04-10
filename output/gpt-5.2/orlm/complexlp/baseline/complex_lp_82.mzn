% Traveling Salesperson Problem (TSP) for 4 cities with embedded data

int: n = 4;
set of int: CITIES = 1..n;

% City indices:
% 1 = Alpha, 2 = Bravo, 3 = Charlie, 4 = Delta

array[CITIES, CITIES] of int: cost =
[
  %   A   B   C   D
  |  0, 41, 55, 22  % Alpha
  | 41,  0, 47, 47  % Bravo
  | 55, 47,  0, 35  % Charlie
  | 22, 47, 35,  0  % Delta
];

% succ[i] is the next city visited after city i (a Hamiltonian cycle)
array[CITIES] of var CITIES: succ;

constraint
  forall(i in CITIES)(succ[i] != i);           % no self-loop
constraint
  all_different(succ);                         % permutation of cities
constraint
  circuit(succ);                               % single cycle visiting all cities once

var int: total_cost = sum(i in CITIES)(cost[i, succ[i]]);

solve minimize total_cost;

array[CITIES] of string: name = ["Alpha","Bravo","Charlie","Delta"];

output [
  "Minimum total delivery cost = ", show(total_cost), "\n",
  "Successor representation (city -> next):\n",
  concat([ name[i] ++ " -> " ++ name[fix(succ[i])] ++ "\n" | i in CITIES ])
];