% Hospital staffing: minimize cost with integer hours.

int: nurse_cost = 7;
int: doctor_cost = 10;

% Decision variables: whole hours worked in the shift
var 0..1000: nurse_hours;
var 0..1000: doctor_hours;

% Constraint 1:
% "At least the equivalent of 20 hours of work from two nurses or one doctor"
% -> 2*nurse_hours + doctor_hours >= 20
constraint 2 * nurse_hours + doctor_hours >= 20;

% Constraint 2:
% "Combined hours worked by one nurse and three doctors cannot exceed 60 hours"
% -> nurse_hours + 3*doctor_hours <= 60
constraint nurse_hours + 3 * doctor_hours <= 60;

% Objective: minimize total staffing cost
var int: total_cost = nurse_cost * nurse_hours + doctor_cost * doctor_hours;
solve minimize total_cost;

output [
  "nurse_hours=", show(nurse_hours), "\n",
  "doctor_hours=", show(doctor_hours), "\n",
  "min_total_cost_rounded=", show(total_cost), "\n"
];