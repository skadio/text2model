% Parameters
% Maximum combined training hours allowed (physical limit)
int: max_total_hours = 20;

% Minimum required difference between X and Y hours (X >= Y + min_diff)
int: min_diff = 5;

% Fatigue per hour for each exercise
int: fatigue_per_hour_X = 2;
int: fatigue_per_hour_Y = 3;

% Individual upper bounds due to availability constraints
int: max_hours_X = 15;
int: max_hours_Y = 10;


% Variables
% Whole hours allocated to exercise X and Y
var 0..max_hours_X: hours_X;
var 0..max_hours_Y: hours_Y;

% Total fatigue (bounded using worst-case within declared variable bounds)
var 0..(fatigue_per_hour_X * max_hours_X + fatigue_per_hour_Y * max_hours_Y): total_fatigue;


% Constraints
% Link total fatigue to chosen training hours (linear definition)
constraint
  total_fatigue = fatigue_per_hour_X * hours_X + fatigue_per_hour_Y * hours_Y;

% Total weekly training time must not exceed the physical limit
constraint
  hours_X + hours_Y <= max_total_hours;

% Exercise X must be scheduled at least min_diff hours more than exercise Y
constraint
  hours_X >= hours_Y + min_diff;


% Objective
solve minimize total_fatigue;