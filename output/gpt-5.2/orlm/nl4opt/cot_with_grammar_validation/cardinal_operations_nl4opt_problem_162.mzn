% Parameters
int: tech_hours = 8;
int: grad_hours = 5;
int: tech_cost = 300;
int: grad_cost = 100;
int: required_hours = 500;
int: budget = 14000;

% Variables
var 0..(budget div tech_cost): tech_shifts;
var 0..(budget div grad_cost): grad_shifts;
var 0..((budget div tech_cost) + (budget div grad_cost)): total_shifts;

% Constraints
constraint tech_shifts * tech_hours + grad_shifts * grad_hours >= required_hours;
constraint tech_cost * tech_shifts + grad_cost * grad_shifts <= budget;
constraint tech_shifts = 2 * grad_shifts;
constraint total_shifts = tech_shifts + grad_shifts;

% Objective
solve minimize total_shifts;