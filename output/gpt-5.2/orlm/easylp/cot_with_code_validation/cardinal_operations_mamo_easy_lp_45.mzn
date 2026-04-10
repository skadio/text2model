% Parameters
int: cost_doctor = 10;
int: cost_nurse  = 20;
int: min_staff   = 50;
int: max_weighted_staff = 120;

% Variables
var 0..max_weighted_staff: doctors;
var 0..max_weighted_staff: nurses;
var 0..(cost_doctor*max_weighted_staff + cost_nurse*max_weighted_staff): total_cost;

% Constraints
constraint doctors + nurses >= min_staff;
constraint 2 * doctors + nurses <= max_weighted_staff;
constraint total_cost = cost_doctor * doctors + cost_nurse * nurses;

% Objective
solve minimize total_cost;