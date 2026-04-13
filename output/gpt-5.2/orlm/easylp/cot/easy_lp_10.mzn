% Parameters (with values embedded)
int: cost_solar = 7;
int: cost_wind  = 5;

% Variables
var 0..100: solar; % number of solar projects (integer, non-negative)
var 0..100: wind;  % number of wind projects (integer, non-negative)

% Constraints
constraint 2 * solar + 3 * wind >= 10;
constraint 4 * solar + 1 * wind <= 15;

% Objective
var int: total_cost = cost_solar * solar + cost_wind * wind;
solve minimize total_cost;

output [
  "solar=", show(solar), "\n",
  "wind=", show(wind), "\n",
  "total_cost=", show(total_cost), "\n"
];