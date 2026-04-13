include "globals.mzn";

% Data (embedded as per instructions)
int: cost_doctor = 10;
int: cost_nurse  = 20;

int: min_effort = 50;      % 2*doctor_hours + nurse_hours >= 50
int: max_work   = 150;     % doctor_hours + 3*nurse_hours <= 150
int: min_diff   = 10;      % doctor_hours - nurse_hours >= 10

% Bounds on weekly workhours (not explicitly given beyond "specific bounds";
% use safe implied bounds from constraints: nonnegative and within max_work)
int: max_hours = max_work;

% Decision variables
var 0..max_hours: doctor_hours;
var 0..max_hours: nurse_hours;

% Constraints
constraint 2 * doctor_hours + nurse_hours >= min_effort;
constraint doctor_hours + 3 * nurse_hours <= max_work;
constraint doctor_hours - nurse_hours >= min_diff;

% Objective: minimize total staffing cost
var int: total_cost = cost_doctor * doctor_hours + cost_nurse * nurse_hours;

solve minimize total_cost;

output [
  "doctor_hours = ", show(doctor_hours), "\n",
  "nurse_hours  = ", show(nurse_hours), "\n",
  "total_cost   = ", show(total_cost), "\n"
];