% Shipping allocation between Route X and Route Y
% Minimize total cost subject to capacity, demand, and service quality constraints.

int: CAP = 1000;          % x + y <= 1000
int: DEMAND = 1500;       % 2x + 3y >= 1500
int: DIFF = 200;          % x >= y + 200

int: COST_X = 50;
int: COST_Y = 70;

var 0..CAP: x;            % shipments on Route X
var 0..CAP: y;            % shipments on Route Y

constraint x + y <= CAP;
constraint 2*x + 3*y >= DEMAND;
constraint x >= y + DIFF;

var int: total_cost = COST_X*x + COST_Y*y;
solve minimize total_cost;

output [
  "Route X shipments (x) = ", show(x), "\n",
  "Route Y shipments (y) = ", show(y), "\n",
  "Minimum total cost ($) = ", show(total_cost), "\n"
];