% Flooring production profit maximization (all data embedded)

% Decision variables (square feet produced weekly)
var 0..40000: laminate;
var 0..20000: carpet;

% Demand constraints (minimums)
constraint laminate >= 15000;
constraint carpet >= 5000;

% Shipping contract: total production minimum
constraint laminate + carpet >= 50000;

% Objective: maximize profit
% Use integer-scaled profits to avoid floating point:
% 2.1 -> 21/10, 3.3 -> 33/10, so maximize 21*laminate + 33*carpet
var int: profit_scaled = 21 * laminate + 33 * carpet;
solve maximize profit_scaled;

output [
  "laminate_sqft=", show(laminate), "\n",
  "carpet_sqft=", show(carpet), "\n",
  "profit=$", show(profit_scaled div 10), ".", show(profit_scaled mod 10), "\n"
];