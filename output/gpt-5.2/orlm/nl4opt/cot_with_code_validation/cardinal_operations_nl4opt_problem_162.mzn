% Parameters
int: tech_hours_per_shift = 8;
int: grad_hours_per_shift = 5;
int: tech_cost_per_shift = 300;
int: grad_cost_per_shift = 100;

int: required_total_hours = 500;
int: budget = 14000;

% Variables
var 0..(budget div tech_cost_per_shift): tech_shifts;
var 0..(budget div grad_cost_per_shift): grad_shifts;

% Constraints
constraint tech_shifts = 2 * grad_shifts;

constraint tech_hours_per_shift * tech_shifts + grad_hours_per_shift * grad_shifts >= required_total_hours;

constraint tech_cost_per_shift * tech_shifts + grad_cost_per_shift * grad_shifts <= budget;

% Objective
solve minimize tech_shifts + grad_shifts;