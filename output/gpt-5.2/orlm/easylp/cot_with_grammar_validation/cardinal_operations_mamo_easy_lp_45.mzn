% Parameters
int: cost_doctor = 10;
int: cost_nurse  = 20;
int: min_staff = 50;          % doctors + nurses >= 50
int: cap_weighted = 120;      % 2*doctors + nurses <= 120

% Variables
var 0..cap_weighted: doctors;
var 0..cap_weighted: nurses;

var 0..(cost_doctor*cap_weighted + cost_nurse*cap_weighted): total_cost;

% Constraints
constraint doctors + nurses >= min_staff;
constraint 2*doctors + nurses <= cap_weighted;

constraint total_cost = cost_doctor*doctors + cost_nurse*nurses;

% Objective
solve minimize total_cost;