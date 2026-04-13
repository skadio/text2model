% Investment allocation problem (all data embedded)

% Decision variables:
% x = number of $1000 units invested in option X
% y = number of $1000 units invested in option Y  (since investments must be whole thousands)
var 0..200: x;
var 0..200: y;

% Parameters (in dollars)
int: budget = 200000;
int: min_score = 400000;

int: costX = 1000;   % $ per unit of x (each unit is $1000)
int: costY = 500;    % $ per unit of y (conceptually $500 per $1000 unit here per statement)

% Constraints
constraint costX * x + costY * y <= budget;
constraint 5 * (costX * x) + 3 * (costY * y) >= min_score;

% Objective: minimize total cost (dollars)
solve minimize costX * x + costY * y;

output [
  "x_units_1000 = ", show(x), "\n",
  "y_units_1000 = ", show(y), "\n",
  "total_cost = ", show(costX * x + costY * y), "\n",
  "score = ", show(5 * (costX * x) + 3 * (costY * y)), "\n"
];