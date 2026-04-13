% Mrs. Watson real-estate investment LP (modeled as a linear optimization problem)

% Data (all embedded)
float: budget = 760000.0;
float: profit_per_dollar_condo = 0.50;
float: profit_per_dollar_detached = 1.0;
float: min_condo_fraction = 0.20;
float: min_detached_investment = 20000.0;

% Decision variables: dollars invested in each option
var 0.0..budget: condo;
var 0.0..budget: detached;

% Total investment cannot exceed budget
constraint condo + detached <= budget;

% At least 20% of invested money must be in condos:
% condo >= 0.2 * (condo + detached)  <=>  0.8*condo - 0.2*detached >= 0
constraint (1.0 - min_condo_fraction) * condo - min_condo_fraction * detached >= 0.0;

% At least $20000 must be invested in detached houses
constraint detached >= min_detached_investment;

% Objective: maximize total profit
var float: total_profit = profit_per_dollar_condo * condo + profit_per_dollar_detached * detached;

solve maximize total_profit;

output [
  "Condo investment: $", show(condo), "\n",
  "Detached investment: $", show(detached), "\n",
  "Total invested: $", show(condo + detached), "\n",
  "Total profit: $", show(total_profit), "\n"
];