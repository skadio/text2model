% Parameters
int: nurse_cost = 7;
int: doctor_cost = 10;

int: required_equiv = 20;   % at least 20 hours equivalent
int: budget_limit = 60;     % combined hours limit

% Variables
var 0..budget_limit: nurse_hours;
var 0..budget_limit: doctor_hours;

var 0..(nurse_cost * budget_limit + doctor_cost * budget_limit): total_cost;

% Constraints
constraint 2 * nurse_hours + doctor_hours >= required_equiv;
constraint nurse_hours + 3 * doctor_hours <= budget_limit;

constraint total_cost = nurse_cost * nurse_hours + doctor_cost * doctor_hours;

% Objective
solve minimize total_cost;