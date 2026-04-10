% Hospital staffing cost minimization
% Data embedded as required.

int: min_total_staff = 20;
int: max_diff = 10;

int: cost_doctor = 10;
int: cost_nurse  = 5;

% Decision variables (integers, nonnegative)
var 0..1000: doctors;
var 0..1000: nurses;

% Constraints
constraint doctors + nurses >= min_total_staff;
constraint abs(2 * doctors - nurses) <= max_diff;

% Objective: minimize total cost per day
var int: total_cost = cost_doctor * doctors + cost_nurse * nurses;

solve minimize total_cost;

output [
  "doctors = ", show(doctors), "\n",
  "nurses = ", show(nurses), "\n",
  "total_cost = ", show(total_cost), "\n"
];