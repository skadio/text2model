% Parameters (with values embedded)
int: total_budget = 3000;
float: clothing_return = 0.07;
float: tech_return = 0.10;
int: max_tech_invest = 500;
int: ratio_clothing_to_tech = 4;

% Variables
var 0..total_budget: clothing_invest;
var 0..max_tech_invest: tech_invest;

% Constraints
constraint clothing_invest + tech_invest <= total_budget;
constraint clothing_invest >= ratio_clothing_to_tech * tech_invest;

% Objective
var float: profit = clothing_return * int2float(clothing_invest)
                  + tech_return * int2float(tech_invest);

solve maximize profit;