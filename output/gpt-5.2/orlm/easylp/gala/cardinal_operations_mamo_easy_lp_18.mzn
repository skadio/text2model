% Green energy expansion: minimize total cost with integer capacities

% Data (embedded as required)
int: solar_cost = 50;
int: wind_cost  = 60;

int: min_total_capacity = 1000;
int: max_3solar_minus_wind = 500;

% Decision variables (whole-number capacities)
% Upper bounds chosen safely from constraints: s + w >= 1000 and 3s - w <= 500
% For minimal cost, capacities won't need to exceed 1000 in an optimal solution.
var 0..1000: solar;
var 0..1000: wind;

% Constraints
constraint solar + wind >= min_total_capacity;
constraint 3 * solar - wind <= max_3solar_minus_wind;

% Objective: minimize total cost
var int: total_cost = solar_cost * solar + wind_cost * wind;

solve minimize total_cost;

output [
  "solar = ", show(solar), "\n",
  "wind = ", show(wind), "\n",
  "min_total_cost = $", show(total_cost), "\n"
];