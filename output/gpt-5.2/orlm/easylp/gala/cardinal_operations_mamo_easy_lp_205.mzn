% Hospital staffing allocation (integer linear optimization)

int: cost_doc = 10;
int: cost_nurse = 20;
int: cost_tech = 30;

int: min_units = 50;          % 2*doctors + 3*nurses >= 50
int: max_total_staff = 100;   % doctors + nurses + techs <= 100
int: min_diff_tech_nurse = 10; % techs - nurses >= 10

% Decision variables (whole numbers of individuals)
var 0..max_total_staff: doctors;
var 0..max_total_staff: nurses;
var 0..max_total_staff: technicians;

% Constraints
constraint 2 * doctors + 3 * nurses >= min_units;
constraint doctors + nurses + technicians <= max_total_staff;
constraint technicians - nurses >= min_diff_tech_nurse;

% Objective: minimize total cost
var int: total_cost = cost_doc * doctors + cost_nurse * nurses + cost_tech * technicians;

solve minimize total_cost;

output [
  "Minimum total cost = $", show(total_cost), "\n",
  "Doctors = ", show(doctors), "\n",
  "Nurses = ", show(nurses), "\n",
  "Technicians = ", show(technicians), "\n"
];