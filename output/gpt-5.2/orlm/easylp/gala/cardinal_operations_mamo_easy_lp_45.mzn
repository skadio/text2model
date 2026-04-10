include "globals.mzn";

% Data (embedded as requested)
int: cost_doctor = 10;
int: cost_nurse  = 20;

int: min_staff = 50;     % doctors + nurses >= 50
int: max_weighted = 120; % 2*doctors + nurses <= 120

% Decision variables (whole numbers)
var 0..max_weighted: doctors;
var 0..max_weighted: nurses;

% Constraints
constraint doctors + nurses >= min_staff;
constraint 2*doctors + nurses <= max_weighted;

% Objective: minimize total cost per shift
var 0..1000000: total_cost = cost_doctor*doctors + cost_nurse*nurses;

solve minimize total_cost;

output [
  "Minimum total cost per shift = $", show(total_cost), "\n",
  "doctors = ", show(doctors), "\n",
  "nurses  = ", show(nurses), "\n"
];