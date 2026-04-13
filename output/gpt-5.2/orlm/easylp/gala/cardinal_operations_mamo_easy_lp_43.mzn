% Healthcare center staffing allocation (doctors, nurses)
% Minimize total working hours subject to service constraints.

include "globals.mzn";

% Data (embedded from problem statement)
int: doc_hours = 4;
int: nurse_hours = 6;

% Decision variables: whole numbers of doctors and nurses
var 0..100: doctors;
var 0..100: nurses;

% Total working hours to minimize
var 0..10000: total_hours = doc_hours * doctors + nurse_hours * nurses;

% Constraints
% 2 doctors + 3 nurses must provide at least 10 hours
constraint 2 * doc_hours * doctors + 3 * nurse_hours * nurses >= 10;

% 5 doctors + 1 nurse cannot exceed 20 hours
constraint 5 * doc_hours * doctors + 1 * nurse_hours * nurses <= 20;

solve minimize total_hours;

output [
  "doctors = ", show(doctors), "\n",
  "nurses  = ", show(nurses), "\n",
  "min_total_hours = ", show(total_hours), "\n"
];