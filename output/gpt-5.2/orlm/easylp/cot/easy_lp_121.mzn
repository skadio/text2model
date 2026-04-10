% Parameters (with values embedded)
int: max_budget = 1000;
int: min_effectiveness = 500;
int: max_diff = 200;
int: costX = 500;
int: costY = 300;

% Variables
var 0..max_budget: X;
var 0..max_budget: Y;
var 0..(costX*max_budget + costY*max_budget): total_cost;

% Constraints
constraint X + Y <= max_budget;
constraint 2*X + Y >= min_effectiveness;
constraint abs(X - Y) <= max_diff;
constraint total_cost = costX*X + costY*Y;

% Objective
solve minimize total_cost;

output [
  "X=", show(X), "\n",
  "Y=", show(Y), "\n",
  "total_cost=", show(total_cost), "\n"
];