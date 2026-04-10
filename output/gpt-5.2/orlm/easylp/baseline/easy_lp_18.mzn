% Green energy capacity expansion: minimize cost with integer capacities

int: cost_solar = 50;
int: cost_wind  = 60;

int: min_total_capacity = 1000;
int: max_three_solar_minus_wind = 500;

% Decision variables (whole-number capacities)
var 0..100000: solar;
var 0..100000: wind;

% Objective: minimize total cost
var int: total_cost = cost_solar * solar + cost_wind * wind;

constraint solar + wind >= min_total_capacity;
constraint 3 * solar - wind <= max_three_solar_minus_wind;

solve minimize total_cost;

output [
  "solar = ", show(solar), "\n",
  "wind = ", show(wind), "\n",
  "minimum_total_cost_dollars = ", show(total_cost), "\n"
];