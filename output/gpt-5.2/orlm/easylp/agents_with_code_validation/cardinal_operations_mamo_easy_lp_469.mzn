% Parameters
int: total_hours_limit = 10;              % Max combined hours for X and Y
int: min_effectiveness = 30;              % Minimum required effectiveness score
int: eff_per_hour_x = 3;                  % Effectiveness contribution per hour of X
int: eff_per_hour_y = 4;                  % Effectiveness contribution per hour of Y
int: max_diff_hours = 2;                  % |X - Y| must be <= this
int: fatigue_per_hour_x = 40;             % Fatigue score per hour of X
int: fatigue_per_hour_y = 60;             % Fatigue score per hour of Y
int: max_hours_x = 6;                     % Upper bound on hours for X
int: max_hours_y = 8;                     % Upper bound on hours for Y

% Variables
var 0..max_hours_x: hours_x;              % Integer training hours for exercise X
var 0..max_hours_y: hours_y;              % Integer training hours for exercise Y
var 0..(fatigue_per_hour_x*max_hours_x + fatigue_per_hour_y*max_hours_y): total_fatigue;
                                         % Total fatigue score (objective)

% Constraints
% --- Total hours limit (time constraint) ---
constraint
  hours_x + hours_y <= total_hours_limit;

% --- Minimum effectiveness requirement ---
constraint
  eff_per_hour_x * hours_x + eff_per_hour_y * hours_y >= min_effectiveness;

% --- Balanced training: difference in hours bounded ---
constraint
  abs(hours_x - hours_y) <= max_diff_hours;

% --- Define total fatigue as a linear function of hours ---
constraint
  total_fatigue = fatigue_per_hour_x * hours_x + fatigue_per_hour_y * hours_y;

% Objective
solve minimize total_fatigue;

output [
  "hours_x=", show(hours_x), "\n",
  "hours_y=", show(hours_y), "\n",
  "total_fatigue=", show(total_fatigue), "\n"
];