% Tourism promotion budget allocation (all data embedded)

int: max_total_budget = 1000;
int: min_effectiveness = 500;
int: max_diff = 200;

% Cost per unit budget (in dollars, since each unit = $1)
int: costX = 500;
int: costY = 300;

var 0..max_total_budget: X; % budget for campaign X (integer units)
var 0..max_total_budget: Y; % budget for campaign Y (integer units)

constraint X + Y <= max_total_budget;
constraint 2*X + Y >= min_effectiveness;
constraint abs(X - Y) <= max_diff;

var int: total_cost = costX * X + costY * Y;

solve minimize total_cost;

output [
  "X=", show(X), "\n",
  "Y=", show(Y), "\n",
  "min_total_cost_dollars=", show(total_cost), "\n"
];