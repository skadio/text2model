% Dairy processing production planning (all data embedded)

% Decision variables:
% x1 = kg of product A1 produced per day
% x2 = kg of product A2 produced per day
var 0.0..100.0: x1;              % Type A equipment capacity: max 100 kg/day
var 0.0..float_max: x2;

% Parameters
float: profit1 = 24.0;           % yuan per kg of A1
float: profit2 = 16.0;           % yuan per kg of A2

float: milk_supply = 50.0;       % barrels/day
float: labor_hours = 480.0;      % hours/day

% Conversion rates and time per barrel
% 1 barrel -> 3 kg A1 in 12 hours (Type A)
% 1 barrel -> 4 kg A2 in 8 hours (Type B)
float: kg_per_barrel_A1 = 3.0;
float: kg_per_barrel_A2 = 4.0;
float: hours_per_barrel_A1 = 12.0;
float: hours_per_barrel_A2 = 8.0;

% Derived per-kg requirements
float: barrels_per_kg_A1 = 1.0 / kg_per_barrel_A1;      % = 1/3
float: barrels_per_kg_A2 = 1.0 / kg_per_barrel_A2;      % = 1/4
float: hours_per_kg_A1 = hours_per_barrel_A1 / kg_per_barrel_A1; % = 4
float: hours_per_kg_A2 = hours_per_barrel_A2 / kg_per_barrel_A2; % = 2

% Constraints
constraint barrels_per_kg_A1 * x1 + barrels_per_kg_A2 * x2 <= milk_supply;
constraint hours_per_kg_A1 * x1 + hours_per_kg_A2 * x2 <= labor_hours;

% Objective: maximize profit
var float: total_profit = profit1 * x1 + profit2 * x2;
solve maximize total_profit;

output [
  "A1_kg = ", show(x1), "\n",
  "A2_kg = ", show(x2), "\n",
  "Profit_yuan = ", show(total_profit), "\n"
];