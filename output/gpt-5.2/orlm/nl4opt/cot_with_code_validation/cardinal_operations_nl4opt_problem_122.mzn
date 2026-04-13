% Investment LP (linearized to avoid float/int mixing and improve solver performance)

% Parameters (embedded data)
int: budget = 760000;
int: min_house_invest = 20000;

% Decision variables (dollars invested)
var 0..budget: condo;
var 0..budget: house;

% Constraints
constraint condo + house <= budget;

% Minimum 20% of total investment in condos:
% condo >= 0.2*(condo+house)  <=>  5*condo >= condo + house  <=>  4*condo >= house
constraint 4 * condo >= house;

% At least $20000 in detached houses
constraint house >= min_house_invest;

% Objective: maximize profit
% Profit = 0.5*condo + 1.0*house.
% Multiply by 2 to keep it integral: maximize (condo + 2*house)
var int: total_profit_x2 = condo + 2 * house;

solve maximize total_profit_x2;

output [
  "condo = ", show(condo), "\n",
  "house = ", show(house), "\n",
  "total_profit = ", show(total_profit_x2 / 2.0), "\n"
];