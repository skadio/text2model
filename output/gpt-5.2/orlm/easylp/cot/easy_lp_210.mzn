% Parameters (with values embedded)
int: min_total_staff = 100;

int: cost_doctor = 50;
int: cost_nurse = 30;
int: cost_technician = 20;

int: max_diff_doctor_nurse = 10;
int: min_diff_technician_nurse = -5;

% Variables
var 0..1000: Doctors;
var 0..1000: Nurses;
var 0..1000: Technicians;

var 0..50000: TotalCost;

% Constraints
constraint Doctors + Nurses + Technicians >= min_total_staff;

constraint abs(Doctors - Nurses) <= max_diff_doctor_nurse;

constraint Technicians - Nurses >= min_diff_technician_nurse;

constraint TotalCost = cost_doctor * Doctors + cost_nurse * Nurses + cost_technician * Technicians;

% Objective
solve minimize TotalCost;