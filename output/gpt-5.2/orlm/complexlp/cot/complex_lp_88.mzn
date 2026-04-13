% Parameters (with values embedded)
int: n = 5;
set of int: N = 1..n; % 1=E, 2=F, 3=G, 4=H, 5=I

array[N, N] of int: cost =
  [| 0, 65, 10, 25, 82
   | 65, 0, 98, 42, 26
   | 10, 98, 0, 75, 72
   | 25, 42, 75, 0, 46
   | 82, 26, 72, 46, 0 |];

% Variables
array[N] of var N: succ;          % successor of each node in the tour
array[N] of var 1..n: order;      % MTZ ordering variables

% Constraints
constraint circuit(succ);

% MTZ constraints to eliminate subtours (fix order[1] = 1 as an anchor)
constraint order[1] = 1;
constraint forall(i in 2..n)(order[i] >= 2 /\ order[i] <= n);

constraint forall(i in 2..n, j in 2..n where i != j)(
  order[i] - order[j] + n * (succ[i] == j) <= n - 1
);

% Objective
var int: total_cost = sum(i in N)(cost[i, succ[i]]);

solve minimize total_cost;

output [
  "Minimum total delivery cost = ", show(total_cost), "\n",
  "succ = ", show(succ), "\n"
];