% Nurse/Doctor staffing cost minimization (integer hours)

% Data (embedded)
int: nurse_cost = 7;     % $/hour
int: doctor_cost = 10;   % $/hour

% Variables: whole hours worked in the shift
var 0..1000: nurse_hours;
var 0..1000: doctor_hours;

% Constraints
% "Each shift requires at least the equivalent of 20 hours of work from two nurses or one doctor."
% Interpret as: 2 nurse-hours are equivalent to 1 doctor-hour, so requirement is:
% (nurse_hours)/2 + doctor_hours >= 20  ->  nurse_hours + 2*doctor_hours >= 40
constraint nurse_hours + 2 * doctor_hours >= 40;

% "Combined hours worked by one nurse and three doctors cannot exceed 60 hours."
% Interpret as: nurse_hours + 3*doctor_hours <= 60
constraint nurse_hours + 3 * doctor_hours <= 60;

% Objective: minimize total cost
var int: total_cost = nurse_cost * nurse_hours + doctor_cost * doctor_hours;

solve minimize total_cost;

output [
  "Nurse hours = ", show(nurse_hours), "\n",
  "Doctor hours = ", show(doctor_hours), "\n",
  "Minimum total cost (rounded) = $", show(total_cost), "\n"
];