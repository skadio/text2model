% Parameters
int: hours_doctor = 4;
int: hours_nurse  = 6;

int: a1_doc = 2;
int: a1_nur = 3;
int: min_service_hours = 10;

int: a2_doc = 5;
int: a2_nur = 1;
int: max_available_hours = 20;

% Variables
var 0..100: doctors;
var 0..100: nurses;

var 0..10000: total_hours;

% Constraints
constraint total_hours = hours_doctor * doctors + hours_nurse * nurses;

constraint hours_doctor * a1_doc + hours_nurse * a1_nur >= min_service_hours;

constraint hours_doctor * a2_doc + hours_nurse * a2_nur <= max_available_hours;

% Objective
solve minimize total_hours;