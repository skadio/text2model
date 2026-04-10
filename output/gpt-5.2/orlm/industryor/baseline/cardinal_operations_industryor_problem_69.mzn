include "globals.mzn";

int: n = 4;
set of int: C = 1..n;

array[C, C] of int: dist =
 [| 0, 10, 20, 12
  | 10, 0,  5, 10
  | 20, 5,  0,  8
  | 15, 12, 8,  0 |];

array[C] of var C: succ;         % successor city in the tour
array[C] of var 0..n-1: ord;     % MTZ order variables

% No self-loops
constraint forall(i in C)(succ[i] != i);

% Each city has exactly one outgoing and one incoming arc
constraint all_different(succ);

% Fix start city to 1 (symmetry breaking)
constraint ord[1] = 0;
constraint forall(i in 2..n)(ord[i] >= 1);

% MTZ subtour elimination for a single Hamiltonian cycle
constraint forall(i in 2..n, j in 2..n where i != j)(
  ord[i] - ord[j] + n * bool2int(succ[i] == j) <= n - 1
);

var int: total_distance = sum(i in C)(dist[i, succ[i]]);

solve minimize total_distance;

output [
  "total_distance = ", show(total_distance), "\n",
  "succ = ", show(succ), "\n",
  "tour (starting at 1): ",
  "1 -> ", show(succ[1]), " -> ", show(succ[succ[1]]), " -> ",
  show(succ[succ[succ[1]]]), " -> 1\n"
];