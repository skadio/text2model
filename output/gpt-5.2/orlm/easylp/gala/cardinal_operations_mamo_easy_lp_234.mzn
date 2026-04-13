% Crop allocation (integer acres) minimizing total profit

% Data (embedded from problem statement)
int: profit_corn = 3;
int: profit_wheat = 4;
int: profit_soy = 5;

int: limit_weighted = 15000;   % 2*Corn + 3*Wheat <= 15000
int: min_total_acres = 8000;   % Corn + Wheat + Soy >= 8000
int: max_diff_ws = 2000;       % |Wheat - Soy| <= 2000

% Decision variables (acres, integer, nonnegative)
var 0..limit_weighted: corn;
var 0..limit_weighted: wheat;
var 0..limit_weighted: soy;

% Constraints
constraint 2 * corn + 3 * wheat <= limit_weighted;
constraint corn + wheat + soy >= min_total_acres;
constraint abs(wheat - soy) <= max_diff_ws;

% Objective: minimize total profit
var int: total_profit = profit_corn * corn + profit_wheat * wheat + profit_soy * soy;

solve minimize total_profit;

output [
  "corn_acres = ", show(corn), "\n",
  "wheat_acres = ", show(wheat), "\n",
  "soy_acres = ", show(soy), "\n",
  "min_total_profit = ", show(total_profit), "\n"
];