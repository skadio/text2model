% Parameters
int: max_total_drills = 40;            % Upper limit on total number of drills
int: min_weighted_sum = 30;            % Lower bound for (2*X + Y)

int: fatigue_per_X = 2;                % Fatigue increase per drill X
int: fatigue_per_Y = 3;                % Fatigue increase per drill Y

% Variables
var 0..max_total_drills: num_X;        % Number of drill X instances (integer, non-negative)
var 0..max_total_drills: num_Y;        % Number of drill Y instances (integer, non-negative)

var 0..(fatigue_per_X*max_total_drills + fatigue_per_Y*max_total_drills): total_fatigue;
                                       % Total fatigue score (bounded linear expression variable)

% Constraints
% Link total fatigue to the chosen number of drills
constraint
  total_fatigue = fatigue_per_X * num_X + fatigue_per_Y * num_Y;

% Total number of drills cannot exceed the available time
constraint
  num_X + num_Y <= max_total_drills;

% Ensure balanced development: 2*X + Y must meet the minimum requirement
constraint
  2 * num_X + num_Y >= min_weighted_sum;

% Objective
solve minimize total_fatigue;