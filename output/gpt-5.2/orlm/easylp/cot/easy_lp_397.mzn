% Parameters (with values embedded)
int: n = 4;
set of int: P = 1..n;

% Costs for x1..x4
array[P] of int: cost = [5, 7, 3, 4];

% Upper bounds (not specified in the description; using a safe large bound)
array[P] of int: ub = [1000, 1000, 1000, 1000];

% Variables
array[P] of var int: x; % x[1]=x1, x[2]=x2, x[3]=x3, x[4]=x4
var int: total_cost;

% Constraints
constraint forall(i in P) (0 <= x[i] /\ x[i] <= ub[i]);

% 2*x1 + x2 - 0.5*x3 <= 50  -> multiply by 2: 4*x1 + 2*x2 - x3 <= 100
constraint 4*x[1] + 2*x[2] - x[3] <= 100;

% x1 + 2.5*x2 - x4 >= 30 -> multiply by 2: 2*x1 + 5*x2 - 2*x4 >= 60
constraint 2*x[1] + 5*x[2] - 2*x[4] >= 60;

% -0.75*x1 + x3 + x4 <= 20 -> multiply by 4: -3*x1 + 4*x3 + 4*x4 <= 80
constraint -3*x[1] + 4*x[3] + 4*x[4] <= 80;

% -x1 - x2 + 0.6*x4 >= 10 -> multiply by 10: -10*x1 - 10*x2 + 6*x4 >= 100
constraint -10*x[1] - 10*x[2] + 6*x[4] >= 100;

% Objective
constraint total_cost = sum(i in P)(cost[i] * x[i]);
solve minimize total_cost;

output [
  "Minimum total cost = ", show(total_cost), "\n",
  "x1 = ", show(x[1]), "\n",
  "x2 = ", show(x[2]), "\n",
  "x3 = ", show(x[3]), "\n",
  "x4 = ", show(x[4]), "\n"
];