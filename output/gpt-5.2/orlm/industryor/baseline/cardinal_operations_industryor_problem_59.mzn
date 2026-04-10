% Traveling Salesman Problem (start/end at location 1) with embedded data

int: n = 7;
set of int: N = 1..n;

% Symmetric distance matrix (diagonal set to 0)
array[N, N] of int: d =
[| 0, 86, 49, 57, 31, 69, 50
 | 86, 0, 68, 79, 93, 24, 5
 | 49, 68, 0, 16, 7, 72, 67
 | 57, 79, 16, 0, 90, 69, 1
 | 31, 93, 7, 90, 0, 86, 59
 | 69, 24, 72, 69, 86, 0, 81
 | 50, 5, 67, 1, 59, 81, 0 |];

% succ[i] = next node visited after i
array[N] of var N: succ;

% Fix start/end at location 1 by fixing the tour to include node 1 naturally
% (Circuit ensures a single Hamiltonian cycle through all nodes, so node 1 is on it.)
constraint circuit(succ);

% Objective: total tour length
var int: total_dist = sum(i in N)(d[i, succ[i]]);
solve minimize total_dist;

output [
  "total_dist=", show(total_dist), "\n",
  "succ=", show(succ), "\n"
];