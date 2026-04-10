include "globals.mzn";

int: n = 5;
set of int: SHOPS = 1..n;

% Cost matrix (symmetric; diagonal set to 0)
array[SHOPS, SHOPS] of int: cost =
  array2d(SHOPS, SHOPS, [
     0, 13, 87, 76, 50,
    13,  0, 15, 65, 85,
    87, 15,  0, 45, 81,
    76, 65, 45,  0, 80,
    50, 85, 81, 80,  0
  ]);

% Tour representation:
% succ[i] = next shop visited after i (a Hamiltonian cycle)
array[SHOPS] of var SHOPS: succ;

% Each shop has exactly one outgoing and one incoming arc
constraint all_different(succ);
constraint all_different([succ[i] | i in SHOPS]); % incoming uniqueness (redundant but clear)

% No self-loops
constraint forall(i in SHOPS)(succ[i] != i);

% Single cycle through all nodes (subtour elimination via order variables)
array[SHOPS] of var 1..n: ord;
constraint ord[1] = 1;
constraint forall(i in 2..n)(ord[i] >= 2);

constraint forall(i in 2..n, j in 2..n where i != j)(
  (succ[i] = j) -> (ord[j] = ord[i] + 1)
);

constraint forall(i in 2..n)(
  (succ[i] = 1) -> (ord[i] = n)
);

% Total cost of the cycle
var int: total_cost = sum(i in SHOPS)(cost[i, succ[i]]);

solve minimize total_cost;

output [
  "Optimal travel cost = ", show(total_cost), "\n",
  "Successor mapping (shop i -> next) = ", show(succ), "\n"
];