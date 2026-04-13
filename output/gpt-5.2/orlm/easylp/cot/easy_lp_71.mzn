% Parameters (with values embedded)
int: total_acres = 100;
int: profit_wheat = 20;
int: profit_corn  = 30;
int: demand_units = 200;

% Constraint coefficients for demand: 3*wheat + 2*corn >= 200
int: a_wheat = 3;
int: a_corn  = 2;

% Variables
var 0..total_acres: wheat_acres;
var 0..total_acres: corn_acres;
var 0..(profit_wheat*total_acres + profit_corn*total_acres): total_profit;

% Constraints
constraint wheat_acres + corn_acres <= total_acres;
constraint a_wheat * wheat_acres + a_corn * corn_acres >= demand_units;
constraint total_profit = profit_wheat * wheat_acres + profit_corn * corn_acres;

% Objective
solve maximize total_profit;

output [
  "wheat_acres=", show(wheat_acres), "\n",
  "corn_acres=", show(corn_acres), "\n",
  "max_total_profit_dollars=", show(total_profit), "\n"
];