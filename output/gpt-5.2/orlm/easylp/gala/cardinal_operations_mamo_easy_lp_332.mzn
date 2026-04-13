include "globals.mzn";

% Investment decision variables (units of plants/projects)
var 0..3000: solar;
var 0..2500: wind;
var 1000..4000: hydro;
var 1500..3500: nuclear;

% Constraints
constraint solar + wind >= 2000;
constraint hydro + nuclear <= 5000;

% |solar - wind| <= 1000
constraint solar - wind <= 1000;
constraint wind - solar <= 1000;

% hydro at least 500 more than nuclear
constraint hydro >= nuclear + 500;

% Cost coefficients (million dollars per unit)
int: c_solar = 5;
int: c_wind = 10;
int: c_hydro = 20;
int: c_nuclear = 30;

var int: total_cost = c_solar * solar + c_wind * wind + c_hydro * hydro + c_nuclear * nuclear;

solve minimize total_cost;

output [
  "solar   = ", show(solar), "\n",
  "wind    = ", show(wind), "\n",
  "hydro   = ", show(hydro), "\n",
  "nuclear = ", show(nuclear), "\n",
  "total_cost_million = ", show(total_cost), "\n"
];