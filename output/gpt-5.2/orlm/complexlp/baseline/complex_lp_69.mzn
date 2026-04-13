% Traveling Salesman Problem (6 cities) - data embedded

int: n = 6;
set of int: CITIES = 1..n;

array[CITIES, CITIES] of int: cost =
%          1   2   3   4   5   6
[|        0, 83, 30, 38, 87, 55  % 1
 |       90,  0, 93, 13, 42, 72  % 2
 |       40, 41,  0, 85, 17, 66  % 3
 |       75, 19, 35,  0, 58, 24  % 4
 |       87, 42, 68, 51,  0, 36  % 5
 |       22, 79, 49, 61, 28,  0  % 6
 |];

array[CITIES] of var CITIES: succ;

% Each city has exactly one outgoing and one incoming edge (a permutation)
constraint all_different(succ);
constraint all_different([ i | i in CITIES ](inverse(succ)[i])); % ensures 1-1 mapping

% Single Hamiltonian cycle
include "globals.mzn";
constraint circuit(succ);

var int: total_cost = sum(i in CITIES)( cost[i, succ[i]] );

solve minimize total_cost;

output [
  "Minimum total travel cost = ", show(total_cost), "\n",
  "Successor representation (i -> succ[i]):\n",
  concat([ show(i) ++ " -> " ++ show(succ[i]) ++ "\n" | i in CITIES ])
];

% Helper: inverse permutation (MiniZinc doesn't have a built-in inverse for arrays of vars)
function array[int] of var int: inverse(array[int] of var int: p) =
  let { set of int: I = index_set(p); } in
  [ sum(j in I)( bool2int(p[j] = i) * j ) | i in I ];