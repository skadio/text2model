% Budget allocation between goods X and Y

int: max_total_budget = 2000;

int: costX = 2;
int: costY = 3;

int: minX = 0;    int: maxX = 1500;
int: minY = 0;    int: maxY = 1000;

var minX..maxX: x;   % allocation to type X (whole number units)
var minY..maxY: y;   % allocation to type Y (whole number units)

% Total budget constraint (allocations summed)
constraint x + y <= max_total_budget;

% Balance constraint: X at least half of Y plus 500
% x >= 0.5*y + 500  <=>  2x >= y + 1000
constraint 2 * x >= y + 1000;

% Objective: minimize total cost
var int: total_cost = costX * x + costY * y;

solve minimize total_cost;

output [
  "x=", show(x), "\n",
  "y=", show(y), "\n",
  "min_total_cost=", show(total_cost), "\n"
];