% Investment optimization (all data embedded)

float: total_budget = 3000.0;
float: clothing_rate = 0.07;
float: tech_rate = 0.10;
float: clothing_min_multiple = 4.0;  % clothing >= 4 * tech
float: tech_max = 500.0;

% Decision variables (dollars)
var 0.0..total_budget: clothing;
var 0.0..total_budget: tech;

% Constraints
constraint clothing + tech <= total_budget;
constraint clothing >= clothing_min_multiple * tech;
constraint tech <= tech_max;

% Objective: maximize profit
var float: profit = clothing_rate * clothing + tech_rate * tech;
solve maximize profit;

output [
  "clothing = $", show(clothing), "\n",
  "tech = $", show(tech), "\n",
  "profit = $", show(profit), "\n"
];