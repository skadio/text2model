% Parameters
int: patients_per_doctor = 2;          % Patients treated per doctor per day
int: patients_per_nurse  = 3;          % Patients treated per nurse per day
int: min_total_patients  = 10;         % Minimum required patients treated per day
int: max_total_staff     = 12;         % Maximum number of staff (doctors + nurses)

int: cost_per_doctor = 5;              % Cost (investment) per doctor
int: cost_per_nurse  = 3;              % Cost (investment) per nurse

% Variables
var 0..max_total_staff: num_doctors;   % Number of doctors hired (integer, non-negative)
var 0..max_total_staff: num_nurses;    % Number of nurses hired (integer, non-negative)

% Upper bound: worst case hire max_total_staff of each type (loose but valid)
var 0..(cost_per_doctor*max_total_staff + cost_per_nurse*max_total_staff): total_cost;

% Constraints
% Link total_cost to staffing decision variables
constraint
  total_cost = cost_per_doctor * num_doctors + cost_per_nurse * num_nurses;

% Ensure minimum patient treatment capacity is met
constraint
  patients_per_doctor * num_doctors + patients_per_nurse * num_nurses >= min_total_patients;

% Enforce maximum total staff limit
constraint
  num_doctors + num_nurses <= max_total_staff;

% Objective
solve minimize total_cost;