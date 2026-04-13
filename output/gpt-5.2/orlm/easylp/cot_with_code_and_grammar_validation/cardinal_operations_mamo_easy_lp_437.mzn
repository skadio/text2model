% Parameters
int: cost_doctor = 10;
int: cost_nurse  = 20;

int: care_req = 50;          % 2*doctor + nurse >= care_req
int: workload_cap = 150;     % doctor + 3*nurse <= workload_cap
int: diff_req = 10;          % doctor - nurse >= diff_req

% Weekly bounds (not explicitly given; use safe nonnegative bounds)
int: max_hours = 1000;

% Variables
var 0..max_hours: doctor_hours;
var 0..max_hours: nurse_hours;

var 0..(cost_doctor*max_hours + cost_nurse*max_hours): total_cost;

% Constraints
constraint 2 * doctor_hours + nurse_hours >= care_req;
constraint doctor_hours + 3 * nurse_hours <= workload_cap;
constraint doctor_hours - nurse_hours >= diff_req;

constraint total_cost = cost_doctor * doctor_hours + cost_nurse * nurse_hours;

% Objective
solve minimize total_cost;