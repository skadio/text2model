% Parameters
int: min_total_staff = 100;
int: max_diff_doctor_nurse = 10;
int: min_diff_tech_nurse = -5;

int: cost_doctor = 50;
int: cost_nurse = 30;
int: cost_technician = 20;

% Variables
var 0..1000: doctors;
var 0..1000: nurses;
var 0..1000: technicians;

var 0..1000000: total_cost;

% Constraints
constraint doctors + nurses + technicians >= min_total_staff;

constraint abs(doctors - nurses) <= max_diff_doctor_nurse;

constraint technicians - nurses >= min_diff_tech_nurse;

constraint total_cost = cost_doctor * doctors + cost_nurse * nurses + cost_technician * technicians;

% Objective
solve minimize total_cost;