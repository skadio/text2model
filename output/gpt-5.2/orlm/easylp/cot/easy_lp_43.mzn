% Parameters (with values embedded)
int: doctor_hours = 4;
int: nurse_hours  = 6;

int: min_service_hours = 10;     % for 2 doctors and 3 nurses
int: max_available_hours = 20;   % for 5 doctors and 1 nurse

% Variable bounds (derived from max constraint: 5*4*d + 1*6*n <= 20)
int: max_doctors = 1;  % if n=0, 20*d <= 20 -> d <= 1
int: max_nurses  = 3;  % if d=0, 6*n <= 20 -> n <= 3

% Variables
var 0..max_doctors: doctors;
var 0..max_nurses: nurses;
var 0..(doctor_hours*max_doctors + nurse_hours*max_nurses): total_hours;

% Constraints
constraint total_hours = doctor_hours * doctors + nurse_hours * nurses;

% Minimum service level: hours of 2 doctors and 3 nurses at least 10
constraint 2 * doctor_hours * doctors + 3 * nurse_hours * nurses >= min_service_hours;

% Available time: hours of 5 doctors and 1 nurse at most 20
constraint 5 * doctor_hours * doctors + 1 * nurse_hours * nurses <= max_available_hours;

% Objective
solve minimize total_hours;