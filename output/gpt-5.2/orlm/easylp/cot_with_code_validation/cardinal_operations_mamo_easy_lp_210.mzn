% Parameters
int: min_staff = 100;
int: cost_doctor = 50;
int: cost_nurse = 30;
int: cost_tech = 20;

int: max_diff_doctor_nurse = 10;
int: min_diff_tech_nurse = -5;

% Variables
var 0..100000: Doctor;
var 0..100000: Nurse;
var 0..100000: Technician;

var 0..10000000: TotalCost;

% Constraints
constraint Doctor + Nurse + Technician >= min_staff;

constraint abs(Doctor - Nurse) <= max_diff_doctor_nurse;

constraint (Technician - Nurse) >= min_diff_tech_nurse;

constraint TotalCost = cost_doctor * Doctor + cost_nurse * Nurse + cost_tech * Technician;

% Objective
solve minimize TotalCost;