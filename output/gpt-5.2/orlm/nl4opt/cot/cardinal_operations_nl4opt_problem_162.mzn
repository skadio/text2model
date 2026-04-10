% Parameters (with values embedded)
int: hours_per_tech_shift = 8;
int: hours_per_grad_shift = 5;
int: pay_per_tech_shift = 300;
int: pay_per_grad_shift = 100;

int: required_ultrasound_hours = 500;
int: budget = 14000;

% Variables
var 0..2000: tech_shifts;
var 0..2000: grad_shifts;
var 0..4000: total_shifts;

% Constraints
constraint tech_shifts * hours_per_tech_shift + grad_shifts * hours_per_grad_shift >= required_ultrasound_hours;
constraint tech_shifts * pay_per_tech_shift + grad_shifts * pay_per_grad_shift <= budget;

% Regulation: twice as many technician shifts as graduate researcher shifts
constraint tech_shifts = 2 * grad_shifts;

% Define total shifts (total number of scheduled workers/shifts)
constraint total_shifts = tech_shifts + grad_shifts;

% Objective
solve minimize total_shifts;