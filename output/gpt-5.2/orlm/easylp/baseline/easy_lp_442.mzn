% Budget allocation between two departments X and Y (integer dollars)

var 0..1000: x; % budget for department X
var 0..1000: y; % budget for department Y

% Constraints
constraint x + y <= 1000;
constraint 2 * x + y >= 500;
constraint abs(x - y) <= 300;

% Costs per unit (embedded data)
int: costX = 5;
int: costY = 3;

% Objective: minimize total cost
var 0..10000000: total_cost = costX * x + costY * y;
solve minimize total_cost;

output [
  "x = ", show(x), "\n",
  "y = ", show(y), "\n",
  "minimum_total_cost = ", show(total_cost), "\n"
];