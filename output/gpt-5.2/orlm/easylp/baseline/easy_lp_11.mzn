% Resource allocation between two projects (integer optimization)

var 0..100: x; % resources for Project X
var 0..100: y; % resources for Project Y

% Constraints
constraint 4*x + 6*y >= 12;   % minimum output score
constraint 3*x + 5*y <= 15;   % maximum resource consumption

% Objective: minimize total cost
var int: total_cost = 7*x + 10*y;

solve minimize total_cost;

output [
  "x = ", show(x), "\n",
  "y = ", show(y), "\n",
  "minimum_total_cost = $", show(total_cost), "\n"
];