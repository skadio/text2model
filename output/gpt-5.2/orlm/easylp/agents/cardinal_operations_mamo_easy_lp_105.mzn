% Parameters
int: max_total_hours = 15;              % Maximum combined training hours (X + Y)
int: min_strength_hours = 5;            % Minimum hours for strength conditioning (X)
int: min_skill_hours = 3;               % Minimum hours for skill development (Y)
int: fatigue_per_strength_hour = 20;    % Fatigue units per hour of strength conditioning
int: fatigue_per_skill_hour = 30;       % Fatigue units per hour of skill development

% Variables
var min_strength_hours..max_total_hours: X;  % Weekly hours allocated to strength conditioning (integer)
var min_skill_hours..max_total_hours: Y;     % Weekly hours allocated to skill development (integer)

% Upper bound is safe: worst case if both X and Y hit max_total_hours (even though X+Y<=max_total_hours)
var 0..(fatigue_per_strength_hour*max_total_hours + fatigue_per_skill_hour*max_total_hours): total_fatigue;
                                             % Total fatigue score (bounded)

% Constraints
% Total weekly time limit across both training activities
constraint
  X + Y <= max_total_hours;

% Define total fatigue as the linear combination of hours and per-hour fatigue rates
constraint
  total_fatigue = fatigue_per_strength_hour * X + fatigue_per_skill_hour * Y;

% Objective
solve minimize total_fatigue;