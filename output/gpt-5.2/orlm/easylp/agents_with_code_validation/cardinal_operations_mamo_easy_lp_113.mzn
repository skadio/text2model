% Parameters
int: max_total_drills = 40;          % Total drills limit: X + Y <= 40
int: min_balance_requirement = 30;   % Balance requirement: 2*X + Y >= 30

int: fatigue_per_X = 2;              % Fatigue increase per drill X
int: fatigue_per_Y = 3;              % Fatigue increase per drill Y

% Variables
var 0..max_total_drills: x;          % Number of drill X instances (nonnegative integer)
var 0..max_total_drills: y;          % Number of drill Y instances (nonnegative integer)
var 0..(fatigue_per_X*max_total_drills + fatigue_per_Y*max_total_drills): total_fatigue;
                                     % Total fatigue score (bounded)

% Constraints
% Total drills limit (time constraint)
constraint x + y <= max_total_drills;

% Balance requirement (skill development constraint)
constraint 2 * x + y >= min_balance_requirement;

% Total fatigue definition
constraint total_fatigue = fatigue_per_X * x + fatigue_per_Y * y;

% Objective
solve minimize total_fatigue;

% (Optional) Output for inspection
output [
  "x = ", show(x), "\n",
  "y = ", show(y), "\n",
  "total_fatigue = ", show(total_fatigue), "\n"
];