% Supply chain resource allocation between two warehouses

% Data (embedded as required)
int: total_limit = 1000;
int: min_weighted = 800;         % 2*X + Y >= 800
int: max_diff = 200;             % |X - Y| <= 200
int: costX = 4;
int: costY = 3;

% Decision variables (whole number allocations)
var 0..total_limit: x;           % units to warehouse X
var 0..total_limit: y;           % units to warehouse Y

% Constraints
constraint x + y <= total_limit;
constraint 2*x + y >= min_weighted;
constraint abs(x - y) <= max_diff;

% Objective: minimize total cost
var int: total_cost = costX*x + costY*y;

solve minimize total_cost;

output [
  "x = ", show(x), "\n",
  "y = ", show(y), "\n",
  "minimum_total_cost = ", show(total_cost), "\n"
];