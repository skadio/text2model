% Parameters
int: profit_phone = 120;
int: profit_laptop = 40;

int: space_phone = 1;
int: space_laptop = 4;
int: space_total = 400;

int: cost_phone = 400;
int: cost_laptop = 100;
int: budget = 6000;

int: min_laptop_pct = 80; % percent

% Variables
var 0..space_total: phones;
var 0..space_total: laptops;

% Constraints
constraint space_phone * phones + space_laptop * laptops <= space_total;

constraint cost_phone * phones + cost_laptop * laptops <= budget;

% At least 80% of all items are laptops:
% laptops / (phones + laptops) >= 0.8  <=>  laptops >= 0.8*(phones + laptops)
% Multiply by 10 to keep integer linear: 10*laptops >= 8*(phones + laptops)
constraint 10 * laptops >= (min_laptop_pct div 10) * (phones + laptops);

% Objective
solve maximize profit_phone * phones + profit_laptop * laptops;