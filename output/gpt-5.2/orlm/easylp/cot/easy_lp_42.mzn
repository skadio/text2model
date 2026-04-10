% Parameters (with values embedded)
int: patients_per_doctor = 2;
int: patients_per_nurse  = 3;
int: min_total_patients  = 10;

int: max_total_staff     = 12;

int: cost_per_doctor     = 5;
int: cost_per_nurse      = 3;

% Variables
var 0..max_total_staff: doctors;
var 0..max_total_staff: nurses;

var 0..(cost_per_doctor*max_total_staff + cost_per_nurse*max_total_staff): total_cost;

% Constraints
constraint patients_per_doctor * doctors + patients_per_nurse * nurses >= min_total_patients;
constraint doctors + nurses <= max_total_staff;

constraint total_cost = cost_per_doctor * doctors + cost_per_nurse * nurses;

% Objective
solve minimize total_cost;