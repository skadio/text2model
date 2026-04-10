% Parameters
int: hours_per_doctor = 4;          % Hours worked per doctor per day
int: hours_per_nurse  = 6;          % Hours worked per nurse per day

int: min_hours_required  = 10;      % Minimum service level (in hours)
int: max_hours_available = 20;      % Maximum available working time (in hours)

% Coefficients for the constraints (staff counts in each requirement)
int: req1_doctors = 2;
int: req1_nurses  = 3;

int: req2_doctors = 5;
int: req2_nurses  = 1;

% Variables
var 0..ceil(max_hours_available / hours_per_doctor): doctors;  % Number of doctors (nonnegative integer)
var 0..ceil(max_hours_available / hours_per_nurse):  nurses;   % Number of nurses (nonnegative integer)

var 0..max_hours_available: total_hours;                       % Total working hours per day

% Constraints
%--- Total hours definition (linking) ---
constraint
  total_hours = hours_per_doctor * doctors + hours_per_nurse * nurses;

%--- Minimum service level requirement: (2 doctors + 3 nurses) provides at least 10 hours ---
constraint
  (req1_doctors * hours_per_doctor) * doctors
+ (req1_nurses  * hours_per_nurse)  * nurses
>= min_hours_required;

%--- Maximum available working time: (5 doctors + 1 nurse) provides at most 20 hours ---
constraint
  (req2_doctors * hours_per_doctor) * doctors
+ (req2_nurses  * hours_per_nurse)  * nurses
<= max_hours_available;

% Objective
solve minimize total_hours;