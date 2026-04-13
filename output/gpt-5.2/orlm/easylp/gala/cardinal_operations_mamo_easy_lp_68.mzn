% Crop planning MILP (integer acres)
% Data embedded as requested.

int: max_acres = 50;
int: min_total = 40;

int: costX = 5;
int: costY = 10;

% Decision variables (integer acres)
var 0..max_acres: x;  % acres of crop X
var 0..max_acres: y;  % acres of crop Y

% Constraints
constraint x + y <= max_acres;
constraint x + y >= min_total;

% At least twice as much X as Y
constraint x >= 2 * y;

% X cannot exceed twice Y by more than 10 acres: x - 2y <= 10
constraint x <= 2 * y + 10;

% Objective: minimize total cost
var 0..(costX*max_acres + costY*max_acres): total_cost;
constraint total_cost = costX * x + costY * y;

solve minimize total_cost;

output [
  "x_acres = ", show(x), "\n",
  "y_acres = ", show(y), "\n",
  "min_cost_dollars = ", show(total_cost), "\n"
];