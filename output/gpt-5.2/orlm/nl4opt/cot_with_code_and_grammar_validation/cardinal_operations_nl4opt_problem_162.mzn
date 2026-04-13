% Parameters
int: tech_hours = 8;
int: grad_hours = 5;
int: tech_cost = 300;
int: grad_cost = 100;
int: min_total_hours = 500;
int: budget = 14000;

% Variables
var 0..(budget div tech_cost): tech_shifts;
var 0..(budget div grad_cost): grad_shifts;

% Constraints
constraint tech_hours * tech_shifts + grad_hours * grad_shifts >= min_total_hours;
constraint tech_cost * tech_shifts + grad_cost * grad_shifts <= budget;
constraint tech_shifts = 2 * grad_shifts;

% Objective
solve minimize tech_shifts + grad_shifts;