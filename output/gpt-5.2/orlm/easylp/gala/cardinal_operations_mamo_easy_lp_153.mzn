% Shipping company vehicle mix optimization (all data embedded)

int: max_total_weight = 40000;
int: min_total_vehicles = 3000;

% Per-vehicle capacities (pounds)
int: capX = 10;
int: capY = 20;

% Per-vehicle costs (dollars)
int: costX = 10;
int: costY = 20;

% Decision variables: number of vehicles of each type (nonnegative integers)
var 0..min_total_vehicles: x;   % type X vehicles
var 0..min_total_vehicles: y;   % type Y vehicles

% Constraints
constraint capX * x + capY * y <= max_total_weight;
constraint x + y >= min_total_vehicles;

% Objective: minimize total cost
var int: total_cost = costX * x + costY * y;

solve minimize total_cost;

output [
  "x = ", show(x), "\n",
  "y = ", show(y), "\n",
  "total_weight = ", show(capX*x + capY*y), "\n",
  "total_vehicles = ", show(x + y), "\n",
  "minimum_total_cost = $", show(total_cost), "\n"
];