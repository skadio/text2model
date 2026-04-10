% Parameters
int: max_drills = 40;
int: min_skill = 30;

int: fatigue_X = 2;
int: fatigue_Y = 3;

% Variables
var 0..max_drills: X;
var 0..max_drills: Y;
var 0..(fatigue_X*max_drills + fatigue_Y*max_drills): total_fatigue;

% Constraints
constraint X + Y <= max_drills;
constraint 2*X + Y >= min_skill;
constraint total_fatigue = fatigue_X*X + fatigue_Y*Y;

% Objective
solve minimize total_fatigue;