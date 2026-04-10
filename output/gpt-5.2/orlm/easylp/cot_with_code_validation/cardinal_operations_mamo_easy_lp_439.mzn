% Parameters
int: cost_doctor = 5;
int: cost_nurse  = 3;

int: demand_min = 50;     % 2*D + N >= 50
int: capacity_max = 100;  % D + 3*N <= 100
int: doctor_margin = 10;  % D >= N + 10

% Variable bounds derived from constraints and non-negativity:
% From D >= N+10 and D + 3N <= 100 => 4N + 10 <= 100 => N <= 22
int: max_nurse = 22;
% From 2D + N >= 50 and N >= 0 => D >= 25
% Also D + 3N <= 100 with N >= 0 => D <= 100
int: min_doctor = 25;
int: max_doctor = 100;

% Variables
var 0..max_nurse: Nurses;
var min_doctor..max_doctor: Doctors;

% Constraints
constraint 2 * Doctors + Nurses >= demand_min;
constraint Doctors + 3 * Nurses <= capacity_max;
constraint Doctors >= Nurses + doctor_margin;

% Objective
var int: total_cost = cost_doctor * Doctors + cost_nurse * Nurses;
solve minimize total_cost;