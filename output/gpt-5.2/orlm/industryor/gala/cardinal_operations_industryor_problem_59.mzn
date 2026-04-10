include "globals.mzn";

int: n = 7;
set of int: N = 1..n;

% Symmetric distance matrix (1-indexed). Diagonal set to 0.
array[N, N] of int: dist =
[
|  0, 86, 49, 57, 31, 69, 50 |
| 86,  0, 68, 79, 93, 24,  5 |
| 49, 68,  0, 16,  7, 72, 67 |
| 57, 79, 16,  0, 90, 69,  1 |
| 31, 93,  7, 90,  0, 86, 59 |
| 69, 24, 72, 69, 86,  0, 81 |
| 50,  5, 67,  1, 59, 81,  0 |
];

% We model the tour as a permutation "next[i]" = city visited after i.
array[N] of var N: next;

% Successor representation forms a Hamiltonian circuit
constraint all_different(next);
constraint circuit(next);

% Fix start/end at location 1 by breaking symmetry:
% we enforce that city 1 goes to the smallest city among {2..n} it can go to,
% which is equivalent to fixing next[1] to a specific value to reduce symmetries.
% (A tour can be rotated and reversed; anchoring at 1 removes rotation.)
% If you prefer a full symmetry break, you can also constrain an ordering between next[1] and prev[1].
constraint next[1] = 2;

% Total distance
var int: total_dist = sum(i in N)( dist[i, next[i]] );

solve minimize total_dist;

output [
  "next = ", show(next), "\n",
  "total_dist = ", show(total_dist), "\n"
];