int: n = 4;
set of int: P = 1..n;

% Costs per unit resource for projects X1..X4
array[P] of int: cost = [500, 400, 300, 200];

% Bounds on allocations (not specified explicitly in the prompt; use nonnegative integers)
array[P] of int: lb = [0, 0, 0, 0];
array[P] of int: ub = [10000, 10000, 10000, 10000]; % sufficiently large caps

array[P] of var int: x;
constraint forall(p in P)(x[p] >= lb[p] /\ x[p] <= ub[p]);

% Constraints from description
constraint x[1] + x[2] <= 1000;
constraint 2*x[2] + x[3] >= 800;
constraint 2*x[1] <= x[3];          % x1 <= 0.5*x3
constraint x[4] <= x[1] - 200;      % at least 200 fewer than x1
constraint x[4] <= x[2] - 150;      % at least 150 fewer than x2

% Objective: minimize total cost
var int: total_cost = sum(p in P)(cost[p] * x[p]);
solve minimize total_cost;

output [
  "x1=", show(x[1]), "\n",
  "x2=", show(x[2]), "\n",
  "x3=", show(x[3]), "\n",
  "x4=", show(x[4]), "\n",
  "total_cost=", show(total_cost), "\n",
  "minimum_total_cost_rounded_up=", show(total_cost), "\n"
];