include "globals.mzn";

int: n = 5; % Cities: 1=E, 2=F, 3=G, 4=H, 5=I

% Travel cost matrix (cost[i,j] = cost from city i to city j)
array[1..n, 1..n] of int: cost =
[
  %   E   F   G   H   I
  |  0, 35, 90, 23, 62  % E
  | 35,  0, 53, 58, 46  % F
  | 90, 53,  0, 28, 91  % G
  | 23, 58, 28,  0, 77  % H
  | 62, 46, 91, 77,  0  % I
];

% next_city[i] = the city visited immediately after city i
array[1..n] of var 1..n: next_city;

% Each city has exactly one outgoing and one incoming arc
constraint all_different(next_city);

% No self-loops
constraint forall(i in 1..n)(next_city[i] != i);

% Ensure a single Hamiltonian cycle (not multiple smaller cycles)
constraint circuit(next_city);

var int: total_cost = sum(i in 1..n)(cost[i, next_city[i]]);

solve minimize total_cost;

output [
  "Minimum total travel cost = ", show(total_cost), "\n",
  "next_city = ", show(next_city), "\n"
];