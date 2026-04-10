% Energy investment planning - minimize total cost (in million dollars)

var 0..3000: solar;
var 0..2500: wind;
var 1000..4000: hydro;
var 1500..3500: nuclear;

% Strategic / regulatory constraints
constraint solar + wind >= 2000;
constraint hydro + nuclear <= 5000;
constraint abs(solar - wind) <= 1000;
constraint hydro >= nuclear + 500;

% Objective: minimize total cost (in million dollars)
var int: total_cost = 5 * solar + 10 * wind + 20 * hydro + 30 * nuclear;
solve minimize total_cost;

output [
  "solar = ", show(solar), "\n",
  "wind = ", show(wind), "\n",
  "hydro = ", show(hydro), "\n",
  "nuclear = ", show(nuclear), "\n",
  "total_cost_million = ", show(total_cost), "\n"
];