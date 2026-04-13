int: min_total_staff = 100;

int: cost_doctor = 50;
int: cost_nurse = 30;
int: cost_technician = 20;

var 0..1000: Doctors;
var 0..1000: Nurses;
var 0..1000: Technicians;

constraint Doctors + Nurses + Technicians >= min_total_staff;

% Difference between Doctors and Nurses must not exceed 10
constraint abs(Doctors - Nurses) <= 10;

% Difference between Technicians and Nurses should not be less than -5:
% Technicians - Nurses >= -5  <=>  Technicians >= Nurses - 5
constraint Technicians - Nurses >= -5;

var int: total_cost = cost_doctor * Doctors + cost_nurse * Nurses + cost_technician * Technicians;

solve minimize total_cost;

output [
  "Doctors=", show(Doctors), "\n",
  "Nurses=", show(Nurses), "\n",
  "Technicians=", show(Technicians), "\n",
  "TotalStaff=", show(Doctors + Nurses + Technicians), "\n",
  "MinTotalCostRounded=", show(total_cost), "\n"
];