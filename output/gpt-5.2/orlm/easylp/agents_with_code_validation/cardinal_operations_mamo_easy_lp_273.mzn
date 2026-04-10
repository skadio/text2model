% Parameters
% Minimum total training hours required
int: min_total_hours = 10;

% Maximum allowed absolute differences between exercise hours
int: max_diff_xy = 4;
int: max_diff_yz = 5;

% Upper bounds on hours for each exercise type
int: max_x = 15;
int: max_y = 20;
int: max_z = 25;

% Fatigue score per hour for each exercise type
int: fatigue_x = 2;
int: fatigue_y = 3;
int: fatigue_z = 1;


% Variables
% Whole number hours allocated to each exercise (bounded by practicality limits)
var 0..max_x: hours_x;
var 0..max_y: hours_y;
var 0..max_z: hours_z;

% Total fatigue score to minimize (bounded using variable bounds)
var 0..(fatigue_x*max_x + fatigue_y*max_y + fatigue_z*max_z): total_fatigue;


% Constraints
% Total training time requirement (at least the minimum total hours)
constraint
  hours_x + hours_y + hours_z >= min_total_hours;

% Maximum absolute difference constraints between exercise allocations
constraint
  abs(hours_x - hours_y) <= max_diff_xy;

constraint
  abs(hours_y - hours_z) <= max_diff_yz;

% Define total fatigue score from the chosen hours and per-hour fatigue rates
constraint
  total_fatigue = fatigue_x * hours_x + fatigue_y * hours_y + fatigue_z * hours_z;


% Objective
solve minimize total_fatigue;