% Parameters
float: costX = 0.5;
float: costY = 0.3;
int: limit = 5000;
int: diffMin = 100;

% Variables
var 0..limit: x;  % activities in Project X
var 0..limit: y;  % activities in Project Y
var 0..ceil(costX*limit + costY*limit): total_cost_scaled;

% Constraints
constraint 2*x + 3*y <= limit;
constraint x - y >= diffMin;

% scale objective by 10 to avoid floating objective (0.5=5/10, 0.3=3/10)
constraint total_cost_scaled = 5*x + 3*y;

% Objective
solve minimize total_cost_scaled;

% (total_cost_scaled / 10) is the total cost in units; rounded to nearest integer:
% rounded = (total_cost_scaled + 5) div 10
output [
  "x=", show(x), "\n",
  "y=", show(y), "\n",
  "total_cost_scaled=", show(total_cost_scaled), "\n",
  "total_cost=", show(total_cost_scaled / 10.0), "\n",
  "rounded_total_cost=", show( (total_cost_scaled + 5) div 10 ), "\n"
];