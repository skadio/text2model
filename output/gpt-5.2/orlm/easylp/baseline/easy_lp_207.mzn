int: BUDGET_MAX = 10000;

int: X_MIN = 2000; % patient care
int: Y_MIN = 1500; % medical research
int: Z_MIN = 500;  % hospital maintenance

float: effX = 0.5;
float: effY = 0.3;
float: effZ = 0.2;

var X_MIN..BUDGET_MAX: X;
var Y_MIN..BUDGET_MAX: Y;
var Z_MIN..BUDGET_MAX: Z;

constraint X + Y + Z <= BUDGET_MAX;

% Objective: minimize total cost (sum of allocations)
var 0..BUDGET_MAX: total_cost = X + Y + Z;

solve minimize total_cost;

output [
  "X=", show(X), "\n",
  "Y=", show(Y), "\n",
  "Z=", show(Z), "\n",
  "total_cost=", show(total_cost), "\n",
  "rounded_total_cost=", show(total_cost), "\n"
];