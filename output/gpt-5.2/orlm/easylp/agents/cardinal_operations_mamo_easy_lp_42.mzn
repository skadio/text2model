% Parameters
% Embedded problem data (no external .dzn required)
int: patients_per_doctor = 2;      % Patients treated per doctor per day
int: patients_per_nurse  = 3;      % Patients treated per nurse per day
int: min_total_patients  = 10;     % Minimum patients that must be treated per day
int: max_total_staff     = 12;     % Maximum number of staff that can be hired (doctors + nurses)

int: cost_per_doctor = 5;          % Cost per doctor
int: cost_per_nurse  = 3;          % Cost per nurse

% Variables
var 0..max_total_staff: num_doctors;  % Number of doctors hired
var 0..max_total_staff: num_nurses;   % Number of nurses hired

% Total staffing cost (safe upper bound when all staff are of the more expensive type)
var 0..(cost_per_doctor * max_total_staff + cost_per_nurse * max_total_staff): total_cost;

% Constraints
% Patient coverage requirement: doctors and nurses together must treat at least the minimum number of patients
constraint
  patients_per_doctor * num_doctors + patients_per_nurse * num_nurses >= min_total_patients;

% Staffing cap: total hired staff cannot exceed the maximum allowed
constraint
  num_doctors + num_nurses <= max_total_staff;

% Cost definition: total_cost equals the sum of per-role costs
constraint
  total_cost = cost_per_doctor * num_doctors + cost_per_nurse * num_nurses;

% Objective
solve minimize total_cost;

output [
  "num_doctors = ", show(num_doctors), "\n",
  "num_nurses = ", show(num_nurses), "\n",
  "total_cost = ", show(total_cost), "\n"
];