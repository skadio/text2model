% Parameters
int: max_drills = 40;
int: min_skill_requirement = 30;

int: fatigue_X = 2;
int: fatigue_Y = 3;

% Variables
var 0..max_drills: x;  % number of drill X
var 0..max_drills: y;  % number of drill Y
var 0..(fatigue_X*max_drills + fatigue_Y*max_drills): total_fatigue;

% Constraints
constraint x + y <= max_drills;
constraint 2*x + y >= min_skill_requirement;
constraint total_fatigue = fatigue_X*x + fatigue_Y*y;

% Objective
solve minimize total_fatigue;