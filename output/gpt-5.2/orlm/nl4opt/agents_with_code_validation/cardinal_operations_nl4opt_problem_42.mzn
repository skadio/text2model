% Parameters
% Effectiveness time per unit (minutes)
float: time_coconut = 0.7;
float: time_lavender = 0.9;

% Content bounds (units)
int: min_coconut = 300;   % at least 300 units of coconut oil
int: max_each = 550;      % at most 550 units of each ingredient

% Ratio bound: coconut <= 3 * lavender
int: max_coconut_multiple_of_lavender = 3;

% Variables
% Units of each ingredient to add (non-negative integers)
var 0..max_each: units_coconut;    % units of coconut oil
var 0..max_each: units_lavender;   % units of lavender

% Total effectiveness time (minutes)
var float: total_time;

% Constraints
% Link total effectiveness time to chosen units (linear expression)
constraint
  total_time = time_coconut * int2float(units_coconut)
             + time_lavender * int2float(units_lavender);

% Minimum required coconut oil content
constraint
  units_coconut >= min_coconut;

% Ratio constraint: coconut oil cannot exceed thrice the lavender amount
constraint
  units_coconut <= max_coconut_multiple_of_lavender * units_lavender;

% Ensure both ingredients are actually added (avoid degenerate solution with zero lavender)
constraint
  units_lavender > 0;

% Objective
solve minimize total_time;