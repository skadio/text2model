% Crop planning MILP (integer) - minimize total planting cost

var 0..1000: x; % units of crop X
var 0..1000: y; % units of crop Y

% Constraints
constraint 2*x + y >= 200;
constraint x + 3*y <= 150;

% Objective: minimize cost
var int: total_cost = 5*x + 10*y;
solve minimize total_cost;

output [
  "x = ", show(x), "\n",
  "y = ", show(y), "\n",
  "minimum_total_cost = ", show(total_cost), "\n"
];