% Parameters
int: min_total_staff = 100;
int: max_diff_doctor_nurse = 10;
int: min_diff_tech_nurse = -5;

int: cost_doctor = 50;
int: cost_nurse = 30;
int: cost_tech = 20;

% Variables
var 0..10000: doctor;
var 0..10000: nurse;
var 0..10000: tech;

var 0..1000000000: total_cost;

% Constraints
constraint doctor + nurse + tech >= min_total_staff;

constraint abs(doctor - nurse) <= max_diff_doctor_nurse;

constraint (tech - nurse) >= min_diff_tech_nurse;

constraint total_cost = cost_doctor * doctor + cost_nurse * nurse + cost_tech * tech;

% Objective
solve minimize total_cost;