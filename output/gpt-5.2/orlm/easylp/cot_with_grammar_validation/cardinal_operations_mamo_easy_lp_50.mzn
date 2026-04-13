% Parameters
int: min_total_staff = 20;
int: max_diff = 10;
int: cost_doctor = 10;
int: cost_nurse = 5;

% Variables
var 0..min_total_staff: doctors;
var 0..min_total_staff: nurses;
var 0..(cost_doctor*min_total_staff + cost_nurse*min_total_staff): total_cost;

% Constraints
constraint doctors + nurses >= min_total_staff;
constraint abs(2*doctors - nurses) <= max_diff;
constraint total_cost = cost_doctor*doctors + cost_nurse*nurses;

% Objective
solve minimize total_cost;