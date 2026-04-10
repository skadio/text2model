int: cost_solar = 10;
int: cost_wind = 15;
int: cost_nuclear = 20;

int: min_total_production = 10000;
int: max_diff_solar_wind = 5000;
int: nuclear_minus_wind_min = 2000;

% Decision variables: whole-number production units from each source
var 0..100000: solar;
var 0..100000: wind;
var 0..100000: nuclear;

% Constraints
constraint solar + wind + nuclear >= min_total_production;
constraint abs(solar - wind) <= max_diff_solar_wind;
constraint nuclear >= wind + nuclear_minus_wind_min;

% Objective: minimize total investment cost
var int: total_cost = cost_solar * solar + cost_wind * wind + cost_nuclear * nuclear;
solve minimize total_cost;

output [
  "solar=", show(solar), "\n",
  "wind=", show(wind), "\n",
  "nuclear=", show(nuclear), "\n",
  "total_production=", show(solar + wind + nuclear), "\n",
  "total_cost=", show(total_cost), "\n"
];