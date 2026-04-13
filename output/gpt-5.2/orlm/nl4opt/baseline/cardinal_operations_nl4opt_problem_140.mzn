% Candy mix optimization (all data embedded)

float: reg_in_regular_mix = 0.8;
float: sour_in_regular_mix = 0.2;
float: profit_regular_mix = 3.0;

float: reg_in_sour_mix = 0.1;
float: sour_in_sour_mix = 0.9;
float: profit_sour_mix = 5.0;

float: available_regular = 80.0;
float: available_sour = 60.0;

var float: x; % kg of regular mix
var float: y; % kg of sour surprise mix

constraint x >= 0.0 /\ y >= 0.0;

% Resource constraints
constraint reg_in_regular_mix * x + reg_in_sour_mix * y <= available_regular;
constraint sour_in_regular_mix * x + sour_in_sour_mix * y <= available_sour;

% Objective: maximize profit
var float: total_profit = profit_regular_mix * x + profit_sour_mix * y;
solve maximize total_profit;

output [
  "Regular mix (kg) = ", show(x), "\n",
  "Sour surprise mix (kg) = ", show(y), "\n",
  "Total profit ($) = ", show(total_profit), "\n"
];