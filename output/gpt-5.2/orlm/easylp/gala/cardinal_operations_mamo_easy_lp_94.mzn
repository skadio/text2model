% Supply chain distribution optimization (integer linear program)

% Data (embedded as requested)
int: min_total_goods = 1000;
int: max_capacity = 2500;

int: costX = 5;   % $ per unit to warehouse X
int: costY = 3;   % $ per unit to warehouse Y

% Decision variables (whole units)
var 0..max_capacity: x;  % units sent to warehouse X
var 0..max_capacity: y;  % units sent to warehouse Y

% Constraints
constraint x + y >= min_total_goods;
constraint 2*x + y <= max_capacity;

% Objective: minimize total cost
var int: total_cost = costX*x + costY*y;
solve minimize total_cost;

output [
  "x = ", show(x), "\n",
  "y = ", show(y), "\n",
  "total_cost = ", show(total_cost), "\n"
];