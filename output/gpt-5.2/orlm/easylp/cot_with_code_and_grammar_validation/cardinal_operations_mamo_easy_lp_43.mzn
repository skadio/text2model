% Parameters
int: doctor_hours = 4;
int: nurse_hours  = 6;

int: min_service_hours = 10;   % for 2 doctors and 3 nurses
int: max_available_hours = 20; % for 5 doctors and 1 nurse

% Variables
var 0..100: D; % number of doctors (integer, non-negative)
var 0..100: N; % number of nurses  (integer, non-negative)
var 0..1000: total_hours;

% Constraints
constraint total_hours = doctor_hours * D + nurse_hours * N;

constraint 2 * doctor_hours * D + 3 * nurse_hours * N >= min_service_hours;
constraint 5 * doctor_hours * D + 1 * nurse_hours * N <= max_available_hours;

% Objective
solve minimize total_hours;