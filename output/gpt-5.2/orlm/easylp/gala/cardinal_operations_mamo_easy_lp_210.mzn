include "globals.mzn";

% Data (embedded as requested)
int: min_total_staff = 100;

int: cost_doctor = 50;
int: cost_nurse = 30;
int: cost_tech = 20;

int: max_diff_doctor_nurse = 10;   % |D - N| <= 10
int: min_diff_tech_nurse = -5;     % (T - N) >= -5  i.e., T >= N - 5

% Decision variables (whole numbers of staff)
var 0..100000: D;  % Doctors
var 0..100000: N;  % Nurses
var 0..100000: T;  % Technicians

% Constraints
constraint D + N + T >= min_total_staff;
constraint abs(D - N) <= max_diff_doctor_nurse;
constraint T - N >= min_diff_tech_nurse;

% Objective: minimize total staffing cost
var 0..intmax: total_cost = cost_doctor * D + cost_nurse * N + cost_tech * T;

solve minimize total_cost;

output [
  "Doctors = ", show(D), "\n",
  "Nurses = ", show(N), "\n",
  "Technicians = ", show(T), "\n",
  "Total staff = ", show(D + N + T), "\n",
  "Minimum total cost (rounded) = ", show(total_cost), "\n"
];