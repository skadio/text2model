% Parameters
int: total_budget = 600000;
int: apt_max = 200000;
float: apt_return = 0.10;
float: town_return = 0.15;

% Variables
var 0..total_budget: apt_invest;
var 0..total_budget: town_invest;
var float: profit;

% Constraints
constraint apt_invest + town_invest = total_budget;
constraint apt_invest <= apt_max;
constraint apt_invest >= 0.5 * town_invest;

constraint profit = apt_return * apt_invest + town_return * town_invest;

% Objective
solve maximize profit;