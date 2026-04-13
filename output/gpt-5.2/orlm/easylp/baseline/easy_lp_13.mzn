int: cost_solar = 4;
int: cost_wind  = 5;

int: min_power = 10;
int: max_diff  = 5;

var 0..1000: solar;
var 0..1000: wind;

constraint 3 * solar + 2 * wind >= min_power;
constraint abs(solar - wind) <= max_diff;

var int: total_cost = cost_solar * solar + cost_wind * wind;

solve minimize total_cost;

output [
  "solar=", show(solar), "\n",
  "wind=", show(wind), "\n",
  "total_cost=", show(total_cost), "\n"
];