% Parameters
int: hrs_doctor = 4;
int: hrs_nurse  = 6;

int: min_service_hours = 10; % for 2 doctors and 3 nurses
int: max_available_hours = 20; % for 5 doctors and 1 nurse

% Variables
var 0..100: doctors;
var 0..100: nurses;

var 0..(hrs_doctor*100 + hrs_nurse*100): total_hours;

% Constraints
constraint total_hours = hrs_doctor * doctors + hrs_nurse * nurses;

constraint 2 * hrs_doctor * doctors + 3 * hrs_nurse * nurses >= min_service_hours;
constraint 5 * hrs_doctor * doctors + 1 * hrs_nurse * nurses <= max_available_hours;

% Objective
solve minimize total_hours;