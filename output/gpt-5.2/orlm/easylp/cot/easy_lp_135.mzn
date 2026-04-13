% Parameters (with values embedded)
int: budget = 20;
int: impact_min = 10;
int: costX = 4;
int: costY = 5;

% Variables
var 0..budget: x;  % investment in Project X (integer units)
var 0..budget: y;  % investment in Project Y (integer units)
var 0..(costX*budget + costY*budget): total_cost;

% Constraints
constraint x + y <= budget;
constraint 2*x + y >= impact_min;
constraint total_cost = costX*x + costY*y;

% Objective
solve minimize total_cost;

output [
  "x=", show(x), " y=", show(y), " total_cost=", show(total_cost), "\n"
];