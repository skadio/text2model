% Traveling Salesperson Problem with 5 cities
int: n = 5;
set of int: CITIES = 1..n;

array[CITIES, CITIES] of int: cost =
[
  % to:   1   2   3   4   5
        [  0, 40, 40, 56, 93], % from 1
        [ 40,  0, 52, 71, 90], % from 2
        [ 40, 52,  0, 57, 14], % from 3
        [ 56, 71, 57,  0, 13], % from 4
        [ 93, 90, 14, 13,  0]  % from 5
];

% succ[i] = next city visited after i (Hamiltonian cycle representation)
array[CITIES] of var CITIES: succ;

% Enforce a single tour visiting all cities exactly once
constraint circuit(succ);

var int: total_cost =
  sum(i in CITIES)(cost[i, succ[i]]);

solve minimize total_cost;

output [
  "Minimum total travel cost = ", show(total_cost), "\n",
  "Successor array (succ[i]=next city after i): ", show(succ), "\n"
];