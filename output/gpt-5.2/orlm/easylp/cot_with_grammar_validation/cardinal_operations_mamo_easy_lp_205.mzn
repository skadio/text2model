% Parameters
int: cost_doctor = 10;
int: cost_nurse = 20;
int: cost_technician = 30;

int: min_work_units = 50;
int: max_total_staff = 100;
int: min_tech_minus_nurse = 10;

% Variables
var 0..max_total_staff: doctors;
var 0..max_total_staff: nurses;
var 0..max_total_staff: technicians;

var 0..(cost_doctor*max_total_staff + cost_nurse*max_total_staff + cost_technician*max_total_staff): total_cost;

% Constraints
constraint 2 * doctors + 3 * nurses >= min_work_units;

constraint doctors + nurses + technicians <= max_total_staff;

constraint technicians - nurses >= min_tech_minus_nurse;

constraint total_cost = cost_doctor * doctors + cost_nurse * nurses + cost_technician * technicians;

% Objective
solve minimize total_cost;