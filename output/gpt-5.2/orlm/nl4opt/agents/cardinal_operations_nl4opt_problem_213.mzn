% Parameters
% Transport capacities (people per minute)
int: cap_escalator = 20;
int: cap_elevator  = 8;

% Space usage (units of space)
int: space_escalator = 5;
int: space_elevator  = 2;

% Requirements
int: min_people_per_min = 400;
int: min_elevators = 2;
int: escalator_to_elevator_ratio = 3; % escalators >= 3 * elevators

% Useful upper bounds (derived from requirements; keep integer)
% If all capacity were provided by escalators: 20*E >= 400 => E >= 20
int: ub_escalators = ceil(min_people_per_min / cap_escalator); % 20
% If all capacity were provided by elevators: 8*L >= 400 => L >= 50, so an upper bound of 50 is safe
int: ub_elevators  = ceil(min_people_per_min / cap_elevator);  % 50

% Variables
% Number of escalators installed
var 0..ub_escalators: num_escalators;

% Number of elevators installed
var 0..ub_elevators: num_elevators;

% Total space used (for objective)
var 0..(ub_escalators * space_escalator + ub_elevators * space_elevator): total_space;

% Constraints

% --- Capacity requirement: ensure enough people per minute can be transported ---
constraint
  cap_escalator * num_escalators + cap_elevator * num_elevators >= min_people_per_min;

% --- Ratio requirement: at least three times more escalators than elevators ---
constraint
  num_escalators >= escalator_to_elevator_ratio * num_elevators;

% --- Minimum elevators requirement: at least 2 elevators must be used ---
constraint
  num_elevators >= min_elevators;

% --- Total space definition: link total_space to chosen numbers of devices ---
constraint
  total_space = space_escalator * num_escalators + space_elevator * num_elevators;

% Objective
solve minimize total_space;