% Shipping company vehicle selection (integer optimization)

int: weight_limit = 40000;
int: min_vehicles = 3000;

% Costs per vehicle
int: costX = 10;
int: costY = 20;

% Capacities (pounds) per vehicle type
% Not provided in the description; the only total weight limit is given.
% Thus, model assumes each vehicle counts as 1 pound equivalent toward the limit.
int: capX = 1;
int: capY = 1;

var 0..weight_limit: x; % number of type X vehicles
var 0..weight_limit: y; % number of type Y vehicles

constraint capX * x + capY * y <= weight_limit;
constraint x + y >= min_vehicles;

var int: total_cost = costX * x + costY * y;

solve minimize total_cost;

output [
  "x=", show(x), " y=", show(y), "\n",
  "total_cost=", show(total_cost), "\n"
];