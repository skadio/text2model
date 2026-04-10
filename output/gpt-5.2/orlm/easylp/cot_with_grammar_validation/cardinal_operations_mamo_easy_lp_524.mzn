% Parameters
int: max_total_hours = 100;
int: min_diff_nurse_doctor = 10;
int: max_diff_admin_nurse = 20;
int: min_admin_over_doctor = 30;

int: cost_nurse = 500;
int: cost_doctor = 300;
int: cost_admin = 700;

% Variables
var 0..max_total_hours: X; % nurses hours
var 0..max_total_hours: Y; % doctors hours
var 0..max_total_hours: Z; % admin hours

var 0..(cost_nurse*max_total_hours + cost_doctor*max_total_hours + cost_admin*max_total_hours): total_cost;

% Constraints
constraint X + Y + Z <= max_total_hours;

constraint abs(X - Y) >= min_diff_nurse_doctor;

constraint abs(Z - X) <= max_diff_admin_nurse;

constraint Z >= Y + min_admin_over_doctor;

constraint total_cost = cost_nurse * X + cost_doctor * Y + cost_admin * Z;

% Objective
solve minimize total_cost;