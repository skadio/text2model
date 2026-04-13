% Energy investment optimization: Solar and Wind
% Minimize total cost subject to budget, output, and ordering constraints.
% All data embedded.

int: budget = 80;
int: min_score = 100;

int: solar_cost = 10;
int: wind_cost  = 20;

int: solar_max = 50;
int: wind_max  = 40;

var 0..solar_max: solar;
var 0..wind_max: wind;

constraint solar + wind <= budget;
constraint 3 * solar + 2 * wind >= min_score;
constraint solar >= wind;

var int: total_cost = solar_cost * solar + wind_cost * wind;

solve minimize total_cost;

output [
  "solar=", show(solar), "\n",
  "wind=", show(wind), "\n",
  "total_cost=", show(total_cost), "\n"
];