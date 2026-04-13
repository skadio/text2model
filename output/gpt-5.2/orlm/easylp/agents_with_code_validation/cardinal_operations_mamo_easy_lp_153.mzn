% Data (embedded)
int: max_total_weight = 40000;     % pounds
int: min_total_vehicles = 3000;    % vehicles
int: cost_x = 10;                 % dollars per X
int: cost_y = 20;                 % dollars per Y

% The problem statement does not provide capacities for X and Y.
% Since only a total weight limit is given, we model the simplest consistent case:
% each vehicle counts as 1 unit of "weight capacity usage".
int: capacity_x = 1;
int: capacity_y = 1;

% Decision variables
var 0..min_total_vehicles: num_x;
var 0..min_total_vehicles: num_y;

% Constraints
constraint num_x + num_y >= min_total_vehicles;
constraint capacity_x * num_x + capacity_y * num_y <= max_total_weight;

% Objective: minimize total cost
solve minimize cost_x * num_x + cost_y * num_y;

output [
  "num_x=", show(num_x), "\n",
  "num_y=", show(num_y), "\n",
  "total_cost=", show(cost_x * num_x + cost_y * num_y), "\n"
];