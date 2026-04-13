% Parameters
int: cost_doctor = 5;
int: cost_nurse  = 3;

int: min_service = 50;      % 2*Doctors + Nurses >= 50
int: max_balance = 100;     % Doctors + 3*Nurses <= 100
int: min_diff    = 10;      % Doctors - Nurses >= 10

% Variables
var 0..1000: Doctors;
var 0..1000: Nurses;
var 0..1000000: TotalCost;

% Constraints
constraint 2*Doctors + Nurses >= min_service;
constraint Doctors + 3*Nurses <= max_balance;
constraint Doctors - Nurses >= min_diff;

constraint TotalCost = cost_doctor*Doctors + cost_nurse*Nurses;

% Objective
solve minimize TotalCost;