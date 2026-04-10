% Parameters
int: nurse_cost = 7;
int: doctor_cost = 10;

int: req_hours = 20;          % at least 20 equivalent hours
int: budget_hours_max = 60;   % upper bound on combined hours

% Variables
var 0..req_hours: nurse_hours;
var 0..budget_hours_max: doctor_hours;
var 0..(nurse_cost*req_hours + doctor_cost*budget_hours_max): total_cost;

% Constraints
constraint 2 * nurse_hours + doctor_hours >= req_hours;
constraint nurse_hours + 3 * doctor_hours <= budget_hours_max;

constraint total_cost = nurse_cost * nurse_hours + doctor_cost * doctor_hours;

% Objective
solve minimize total_cost;