% Parameters
int: hours_per_doctor = 4;         % Hours required per doctor per day
int: hours_per_nurse  = 6;         % Hours required per nurse per day

int: min_service_hours = 10;       % Minimum required combined hours for service level
int: max_available_hours = 20;     % Maximum allowed combined hours due to availability

% Coefficients in the two constraints (given in the description)
int: c1_doctors = 2;
int: c1_nurses  = 3;

int: c2_doctors = 5;
int: c2_nurses  = 1;

% Variables
var 0..100: doctors;               % Number of doctors (integer, non-negative)
var 0..100: nurses;                % Number of nurses (integer, non-negative)

var 0..10000: total_hours;         % Total working hours per day (to minimize)


% Constraints

% Link total_hours to the staffing decisions (hours per doctor/nurse)
constraint total_hours = hours_per_doctor * doctors + hours_per_nurse * nurses;

% Minimum service level requirement:
% Combined hours of work for 2 doctors and 3 nurses must be at least min_service_hours
constraint (c1_doctors * hours_per_doctor) * doctors
         + (c1_nurses  * hours_per_nurse)  * nurses
         >= min_service_hours;

% Maximum availability requirement:
% Combined hours of work for 5 doctors and 1 nurse cannot exceed max_available_hours
constraint (c2_doctors * hours_per_doctor) * doctors
         + (c2_nurses  * hours_per_nurse)  * nurses
         <= max_available_hours;


% Objective
solve minimize total_hours;