% Budget allocation between two tourism projects X and Y
% All data embedded directly in the model.

int: TOTAL_BUDGET_MAX = 200;

float: impactX = 0.6;
float: impactY = 0.8;
float: MIN_IMPACT = 120.0;

int: DIFF_MAX_IN_FAVOR_OF_X = 50;

int: X_MAX = 150;
int: Y_MAX = 100;

int: costX = 50;
int: costY = 80;

var 0..X_MAX: X;
var 0..Y_MAX: Y;

% Total budget constraint
constraint X + Y <= TOTAL_BUDGET_MAX;

% Weighted impact constraint
constraint impactX * int2float(X) + impactY * int2float(Y) >= MIN_IMPACT;

% Difference constraint: X - Y cannot exceed 50
constraint X - Y <= DIFF_MAX_IN_FAVOR_OF_X;

% Objective: minimize total cost (already integral, so "rounded up" is itself)
var int: total_cost = costX * X + costY * Y;

solve minimize total_cost;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "minimum_total_cost = ", show(total_cost), "\n"
];