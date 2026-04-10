% Parameters
int: total_budget = 3000;
int: tech_max = 500;
int: clothing_mult = 4;

float: clothing_rate = 0.07;
float: tech_rate = 0.10;

% Variables
var 0..total_budget: clothing;
var 0..min(total_budget, tech_max): tech;

% Constraints
constraint clothing + tech <= total_budget;
constraint clothing >= clothing_mult * tech;

% Objective
var float: profit = clothing_rate * int2float(clothing) + tech_rate * int2float(tech);
solve maximize profit;