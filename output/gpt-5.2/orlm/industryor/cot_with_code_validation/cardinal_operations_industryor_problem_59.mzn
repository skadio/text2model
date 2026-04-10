include "globals.mzn";

%======================
% Data
%======================
int: N = 7;
set of int: V = 1..N;

array[V, V] of int: dist =
  [|  0, 86, 49, 57, 31, 69, 50
   | 86,  0, 68, 79, 93, 24,  5
   | 49, 68,  0, 16,  7, 72, 67
   | 57, 79, 16,  0, 90, 69,  1
   | 31, 93,  7, 90,  0, 86, 59
   | 69, 24, 72, 69, 86,  0, 81
   | 50,  5, 67,  1, 59, 81,  0 |];

%======================
% Decision variables
%======================
array[V] of var V: succ;     % successor of each node in the tour
var int: total_dist;

%======================
% Constraints
%======================
% Single Hamiltonian circuit visiting all nodes exactly once
constraint circuit(succ);

% Total distance
constraint total_dist = sum(i in V)(dist[i, succ[i]]);

%======================
% Objective
%======================
solve minimize total_dist;

output [
  "total_dist = ", show(total_dist), "\n",
  "succ = ", show(succ), "\n"
];