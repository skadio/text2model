% Shipping allocation between Route X and Route Y
% All data embedded as requested.

int: max_total_shipments = 1000;
int: demand_units = 1500;

int: costX = 50;
int: costY = 70;

int: min_diff_X_over_Y = 200; % X >= Y + 200

% Decision variables: number of shipments (whole numbers)
var 0..max_total_shipments: x; % shipments on Route X
var 0..max_total_shipments: y; % shipments on Route Y

% Constraints
constraint x + y <= max_total_shipments;
constraint 2 * x + 3 * y >= demand_units;
constraint x >= y + min_diff_X_over_Y;

% Objective: minimize total cost
var int: total_cost = costX * x + costY * y;

solve minimize total_cost;

output [
  "x (Route X shipments) = ", show(x), "\n",
  "y (Route Y shipments) = ", show(y), "\n",
  "Total cost ($) = ", show(total_cost), "\n"
];