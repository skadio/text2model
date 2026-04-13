include "globals.mzn";

% Parameters
int: n = 7;
set of int: N = 1..n;

array[N, N] of int: d = array2d(N, N, [
  0, 86, 49, 57, 31, 69, 50,
  86, 0, 68, 79, 93, 24, 5,
  49, 68, 0, 16, 7, 72, 67,
  57, 79, 16, 0, 90, 69, 1,
  31, 93, 7, 90, 0, 86, 59,
  69, 24, 72, 69, 86, 0, 81,
  50, 5, 67, 1, 59, 81, 0
]);

% Variables: successor representation of the tour
array[N] of var N: succ;
var int: total_dist;

% Constraints
constraint circuit(succ);

% Fix start at location 1 by breaking rotational symmetry
constraint succ[1] = 2;

% Total distance
constraint total_dist = sum(i in N)(d[i, succ[i]]);

% Objective
solve minimize total_dist;

output [
  "total_dist = ", show(total_dist), "\n",
  "succ = ", show(succ), "\n"
];