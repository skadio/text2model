% Parameters
int: max_total_hours = 50;                 % Total man-hours available across X,Y,Z
int: min_quality_measure = 100;            % Lower bound on 3*X + 4*Y + Z
int: max_secondary_measure = 75;           % Upper bound on 2*X - Y + Z

int: cost_X = 100;                         % Cost per hour for task X
int: cost_Y = 200;                         % Cost per hour for task Y
int: cost_Z = 150;                         % Cost per hour for task Z


% Variables
var 0..max_total_hours: hours_X;            % Integer hours allocated to task X
var 0..max_total_hours: hours_Y;            % Integer hours allocated to task Y
var 0..max_total_hours: hours_Z;            % Integer hours allocated to task Z

% Total cost (safe upper bound: all hours at the most expensive rate)
var 0..(max_total_hours * max(cost_X, max(cost_Y, cost_Z))): total_cost;


% Constraints
% Total hours capacity constraint
constraint
  hours_X + hours_Y + hours_Z <= max_total_hours;

% Minimum required quality/effort constraint: 3*X + 4*Y + Z >= threshold
constraint
  3 * hours_X + 4 * hours_Y + hours_Z >= min_quality_measure;

% Secondary measure upper bound constraint: 2*X - Y + Z <= limit
constraint
  2 * hours_X - hours_Y + hours_Z <= max_secondary_measure;

% Total cost definition constraint
constraint
  total_cost = cost_X * hours_X + cost_Y * hours_Y + cost_Z * hours_Z;


% Objective
solve minimize total_cost;

output [
  "hours_X = ", show(hours_X), "\n",
  "hours_Y = ", show(hours_Y), "\n",
  "hours_Z = ", show(hours_Z), "\n",
  "total_cost = ", show(total_cost), "\n"
];