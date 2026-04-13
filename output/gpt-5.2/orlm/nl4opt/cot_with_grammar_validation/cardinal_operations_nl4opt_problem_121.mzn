% Parameters
float: budget = 500.0;
float: cost_carrot = 0.30;
float: cost_cucumber = 0.50;
float: profit_carrot = 0.75;
float: profit_cucumber = 0.80;

int: carrot_min = 300;
int: carrot_max = 500;

% Variables
var carrot_min..carrot_max: carrots;
var 0..166: cucumbers; % from cucumbers <= floor(carrot_max/3)

% Constraints
constraint cost_carrot * int2float(carrots) + cost_cucumber * int2float(cucumbers) <= budget;
constraint 3 * cucumbers <= carrots;

% Objective
solve maximize profit_carrot * int2float(carrots) + profit_cucumber * int2float(cucumbers);