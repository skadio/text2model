% Hospital staffing cost minimization (all data embedded)

int: cost_doctor = 10;
int: cost_nurse  = 20;

% Bounds on weekly workhours (not specified in the prompt; choose safe non-negative bounds)
int: max_hours = 1000;

var 0..max_hours: doctor_hours;
var 0..max_hours: nurse_hours;

% Constraints
constraint 2 * doctor_hours + nurse_hours >= 50;
constraint doctor_hours + 3 * nurse_hours <= 150;
constraint doctor_hours >= nurse_hours + 10;

% Objective: minimize total staffing cost
var int: total_cost = cost_doctor * doctor_hours + cost_nurse * nurse_hours;
solve minimize total_cost;

output [
  "doctor_hours=", show(doctor_hours), "\n",
  "nurse_hours=", show(nurse_hours), "\n",
  "total_cost=", show(total_cost), "\n"
];