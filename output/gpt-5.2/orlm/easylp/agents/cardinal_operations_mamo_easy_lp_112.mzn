% Parameters
int: max_total_hours = 40;            % Maximum total weekly training hours
int: min_hours_X = 15;               % Minimum required hours of workout X
int: min_hours_Y = 10;               % Minimum required hours of workout Y
int: fatigue_per_hour_X = 2;         % Fatigue points per hour of workout X
int: fatigue_per_hour_Y = 3;         % Fatigue points per hour of workout Y

% Variables
var min_hours_X..max_total_hours: hours_X;   % Weekly hours assigned to workout X (integer hours)
var min_hours_Y..max_total_hours: hours_Y;   % Weekly hours assigned to workout Y (integer hours)

% Upper bound: worst case if both were at max_total_hours (loose but safe)
var 0..(fatigue_per_hour_X*max_total_hours + fatigue_per_hour_Y*max_total_hours): total_fatigue;
                                             % Total fatigue points

% Constraints
% Total weekly training hours cannot exceed the maximum available hours
constraint hours_X + hours_Y <= max_total_hours;

% Total fatigue is the linear combination of fatigue from workouts X and Y
constraint total_fatigue = fatigue_per_hour_X * hours_X + fatigue_per_hour_Y * hours_Y;

% Objective
solve minimize total_fatigue;

output [
  "hours_X=", show(hours_X), "\n",
  "hours_Y=", show(hours_Y), "\n",
  "min_total_fatigue=", show(total_fatigue), "\n"
];