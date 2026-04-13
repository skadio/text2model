% Parameters
int: cost_doctor = 10;
int: cost_nurse  = 20;

int: min_care = 50;         % 2*doctor + nurse >= 50
int: max_work = 150;        % doctor + 3*nurse <= 150
int: min_diff = 10;         % doctor - nurse >= 10

% Variable bounds (weekly integer hours)
int: doctor_lb = 0;
int: doctor_ub = 1000;
int: nurse_lb  = 0;
int: nurse_ub  = 1000;

% Variables
var doctor_lb..doctor_ub: doctor_hours;
var nurse_lb..nurse_ub: nurse_hours;

var 0..(cost_doctor*doctor_ub + cost_nurse*nurse_ub): total_cost;

% Constraints
constraint 2 * doctor_hours + nurse_hours >= min_care;
constraint doctor_hours + 3 * nurse_hours <= max_work;
constraint doctor_hours - nurse_hours >= min_diff;

constraint total_cost = cost_doctor * doctor_hours + cost_nurse * nurse_hours;

% Objective
solve minimize total_cost;