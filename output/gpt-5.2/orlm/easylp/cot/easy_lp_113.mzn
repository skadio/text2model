% Parameters (with values embedded)
int: max_total_drills = 40;
int: min_skill_balance = 30;
int: fatigue_X = 2;
int: fatigue_Y = 3;

% Variables
var 0..max_total_drills: X;
var 0..max_total_drills: Y;

% Constraints
constraint X + Y <= max_total_drills;
constraint 2*X + Y >= min_skill_balance;

% Objective
solve minimize fatigue_X*X + fatigue_Y*Y;