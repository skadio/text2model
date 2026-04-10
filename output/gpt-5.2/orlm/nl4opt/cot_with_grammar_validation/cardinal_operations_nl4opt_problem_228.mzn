% Parameters
int: budget = 3000;
float: r_clothing = 0.07;
float: r_tech = 0.10;
int: tech_max = 500;
int: clothing_min_multiple = 4;

% Variables
var 0..budget: clothing;
var 0..tech_max: tech;
var float: profit;

% Constraints
constraint clothing + tech <= budget;
constraint clothing >= clothing_min_multiple * tech;

constraint profit = r_clothing * int2float(clothing) + r_tech * int2float(tech);

% Objective
solve maximize profit;