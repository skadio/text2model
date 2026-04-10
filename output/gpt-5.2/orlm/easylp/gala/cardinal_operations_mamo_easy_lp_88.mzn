% Shift scheduling / integer linear optimization (embedded data)

% Decision variables: integer hours for groups X and Y
var 0..100: x;  % hours for group X
var 0..100: y;  % hours for group Y

% Constraints
constraint 2*x + 3*y <= 40;
constraint 4*x + y >= 30;

% Cost parameters
int: costX = 8;
int: costY = 12;

% Objective: minimize total labor cost
var int: totalCost = costX*x + costY*y;
solve minimize totalCost;

output [
  "x_hours = ", show(x), "\n",
  "y_hours = ", show(y), "\n",
  "min_total_cost = ", show(totalCost), "\n"
];