% Parameters
int: max_total_drills = 40;
int: min_balance = 30;

int: fatigue_X = 2;
int: fatigue_Y = 3;

% Variables
var 0..max_total_drills: X;
var 0..max_total_drills: Y;
var 0..(fatigue_X*max_total_drills + fatigue_Y*max_total_drills): total_fatigue;

% Constraints
constraint X + Y <= max_total_drills;
constraint 2*X + Y >= min_balance;

constraint total_fatigue = fatigue_X*X + fatigue_Y*Y;

% Objective
solve minimize total_fatigue;