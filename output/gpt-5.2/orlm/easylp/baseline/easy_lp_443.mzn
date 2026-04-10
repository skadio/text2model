% Retail inventory optimization: minimize cost with integer quantities

int: X_min = 0;
int: X_max = 600;
int: Y_min = 0;
int: Y_max = 500;

var X_min..X_max: x;
var Y_min..Y_max: y;

% Constraints
constraint x + y <= 1000;
constraint x - 2*y >= 300;
constraint 3*x + y >= 500;

% Objective: minimize total cost
var int: total_cost = 5*x + 2*y;
solve minimize total_cost;

output [
  "x=", show(x), "\n",
  "y=", show(y), "\n",
  "total_cost=", show(total_cost), "\n",
  "rounded_total_cost=", show(total_cost), "\n"
];