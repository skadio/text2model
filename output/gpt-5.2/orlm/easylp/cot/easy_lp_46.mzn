% Parameters (with values embedded)
int: nurse_cost = 7;          % $/hour
int: doctor_cost = 10;        % $/hour

% Constraint coefficients:
% "Each shift requires at least the equivalent of 20 hours of work from two nurses or one doctor."
% Model: 2*nurse_hours + doctor_hours >= 20
int: req = 20;

% "the combined hours worked by one nurse and three doctors cannot exceed 60 hours."
% Model: nurse_hours + 3*doctor_hours <= 60
int: budget_cap = 60;

% Variable upper bounds (safe finite bounds derived from constraints)
int: max_nurse = budget_cap;                  % nurse_hours <= 60
int: max_doctor = budget_cap div 3;           % 3*doctor_hours <= 60 -> doctor_hours <= 20

% Variables
var 0..max_nurse: nurse_hours;
var 0..max_doctor: doctor_hours;

% Constraints
constraint 2 * nurse_hours + doctor_hours >= req;
constraint nurse_hours + 3 * doctor_hours <= budget_cap;

% Objective
var int: total_cost = nurse_cost * nurse_hours + doctor_cost * doctor_hours;
solve minimize total_cost;