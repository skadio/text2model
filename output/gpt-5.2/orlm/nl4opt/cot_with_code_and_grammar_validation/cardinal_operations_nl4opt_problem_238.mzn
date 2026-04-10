% Parameters
int: profit_phone = 120;
int: profit_laptop = 40;

int: space_phone = 1;
int: space_laptop = 4;
int: space_available = 400;

int: cost_phone = 400;
int: cost_laptop = 100;
int: budget_max = 6000;

% Corporate requirement: at least 80% laptops
% Equivalent linear form: laptops >= 0.8*(phones+laptops) => laptops >= 4*phones
int: laptop_to_phone_ratio_num = 4; % laptops >= 4*phones

% Variables
var 0..space_available: phones;
var 0..space_available: laptops;

% Constraints
constraint space_phone * phones + space_laptop * laptops <= space_available;

constraint cost_phone * phones + cost_laptop * laptops <= budget_max;

constraint laptops >= laptop_to_phone_ratio_num * phones;

% Objective
solve maximize profit_phone * phones + profit_laptop * laptops;