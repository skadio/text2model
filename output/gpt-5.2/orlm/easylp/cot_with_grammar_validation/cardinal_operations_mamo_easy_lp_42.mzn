% Parameters
int: patients_per_doctor = 2;
int: patients_per_nurse  = 3;
int: min_patients        = 10;

int: max_staff           = 12;

int: cost_doctor         = 5;
int: cost_nurse          = 3;

% Variables
var 0..max_staff: doctors;
var 0..max_staff: nurses;

var 0..(max_staff * max(cost_doctor, cost_nurse)): total_cost;

% Constraints
constraint doctors + nurses <= max_staff;

constraint patients_per_doctor * doctors + patients_per_nurse * nurses >= min_patients;

constraint total_cost = cost_doctor * doctors + cost_nurse * nurses;

% Objective
solve minimize total_cost;