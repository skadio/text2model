% Parameters (with values embedded)
int: profit_phone = 120;
int: profit_laptop = 40;

int: space_phone = 1;
int: space_laptop = 4;
int: total_space = 400;

int: cost_phone = 400;
int: cost_laptop = 100;
int: budget = 6000;

% Corporate requirement: at least 80% of all appliances are laptops
% laptops / (phones + laptops) >= 0.8  ->  laptops >= 0.8*(phones+laptops)
% Multiply by 10 to keep integers: 10*laptops >= 8*(phones+laptops) -> 2*laptops >= 8*phones -> laptops >= 4*phones

% Variables
var 0..total_space: phones;
var 0..(total_space div space_laptop): laptops;  % space-based upper bound

% Constraints
constraint space_phone * phones + space_laptop * laptops <= total_space;
constraint cost_phone * phones + cost_laptop * laptops <= budget;
constraint laptops >= 4 * phones;

% Objective
solve maximize profit_phone * phones + profit_laptop * laptops;