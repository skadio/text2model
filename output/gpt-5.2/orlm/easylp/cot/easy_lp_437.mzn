% Parameters (with values embedded)
int: cost_doctor = 10;
int: cost_nurse  = 20;

int: min_care = 50;          % 2*doctor + nurse >= 50
int: max_workload = 150;     % doctor + 3*nurse <= 150
int: min_diff = 10;          % doctor - nurse >= 10

% Bounds on weekly workhours (nonnegative; no other explicit bounds given)
int: max_hours = 150;

% Variables
var 0..max_hours: doctor_hours;
var 0..max_hours: nurse_hours;

var 0..(cost_doctor*max_hours + cost_nurse*max_hours): total_cost;

% Constraints
constraint 2*doctor_hours + nurse_hours >= min_care;
constraint doctor_hours + 3*nurse_hours <= max_workload;
constraint doctor_hours - nurse_hours >= min_diff;

constraint total_cost = cost_doctor*doctor_hours + cost_nurse*nurse_hours;

% Objective
solve minimize total_cost;