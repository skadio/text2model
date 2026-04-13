% Parameters
int: fatigue_X = 10;                 % fatigue per hour for Group X
int: fatigue_Y = 15;                 % fatigue per hour for Group Y
int: fatigue_Z = 20;                 % fatigue per hour for Group Z

int: total_hours_max = 100;          % total training hours per week limit

int: min_diff_XY = 20;               % X - Y must be at least 20
int: max_diff_ZX = 30;               % Z - X must be at most 30

int: X_max = 60;                     % maximum hours for Group X
int: Y_max = 50;                     % maximum hours for Group Y
int: Z_max = 70;                     % maximum hours for Group Z


% Variables
var 0..X_max: hours_X;               % weekly hours allocated to Group X (integer)
var 0..Y_max: hours_Y;               % weekly hours allocated to Group Y (integer)
var 0..Z_max: hours_Z;               % weekly hours allocated to Group Z (integer)

var 0..(fatigue_X*X_max + fatigue_Y*Y_max + fatigue_Z*Z_max): total_fatigue;
                                     % total fatigue score (bounded integer)


% Constraints
% Link total_fatigue to the weighted sum of training hours
constraint
  total_fatigue = fatigue_X * hours_X
                + fatigue_Y * hours_Y
                + fatigue_Z * hours_Z;

% Total weekly training hours must not exceed the overall limit
constraint
  hours_X + hours_Y + hours_Z <= total_hours_max;

% Balance condition: Group X must exceed Group Y by at least the required minimum
constraint
  hours_X - hours_Y >= min_diff_XY;

% Balance condition: Group Z must not exceed Group X by more than the allowed maximum
constraint
  hours_Z - hours_X <= max_diff_ZX;


% Objective
solve minimize total_fatigue;

output [
  "hours_X = ", show(hours_X), "\n",
  "hours_Y = ", show(hours_Y), "\n",
  "hours_Z = ", show(hours_Z), "\n",
  "total_fatigue = ", show(total_fatigue), "\n"
];