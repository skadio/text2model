% Cargo allocation problem (all data embedded)

% Data
int: cap = 500;
int: minX = 200;
int: minY = 100;

% Costs per unit
float: costX = 0.05;
float: costY = 0.10;

% Decision variables (whole-number allocations)
var minX..cap: x;
var minY..cap: y;

% Capacity constraint
constraint x + y <= cap;

% Objective: minimize total cost
var float: total_cost = costX * int2float(x) + costY * int2float(y);
solve minimize total_cost;

% Output: minimum total cost rounded to one decimal place
output [
  show_float(1, total_cost), "\n"
];