% Farmer crop allocation (integer acres) - maximize profit

include "globals.mzn";

% Data (embedded as required)
int: total_acres = 100;
int: profit_wheat = 20;
int: profit_corn  = 30;

% Constraint: "combined output from 3 acres wheat and 2 acres corn at least 200 units"
% Interpreting "a unit represents the yield from an acre" => each acre contributes 1 unit.
% Thus: 3*wheat + 2*corn >= 200.
int: req_units = 200;

% Decision variables (whole acres)
var 0..total_acres: wheat;
var 0..total_acres: corn;

% Land limit
constraint wheat + corn <= total_acres;

% Market/regulation constraint
constraint 3 * wheat + 2 * corn >= req_units;

% Objective: maximize total profit
var int: total_profit = profit_wheat * wheat + profit_corn * corn;

solve maximize total_profit;

output [
  "wheat_acres = ", show(wheat), "\n",
  "corn_acres  = ", show(corn), "\n",
  "max_profit  = ", show(total_profit), "\n"
];