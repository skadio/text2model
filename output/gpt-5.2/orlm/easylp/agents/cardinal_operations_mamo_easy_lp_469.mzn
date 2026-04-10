% Parameters
int: total_hours_limit = 10;              % Max total training hours for X and Y combined
int: effectiveness_min = 30;              % Minimum required effectiveness score

int: eff_per_hour_X = 3;                  % Effectiveness contribution per hour of X
int: eff_per_hour_Y = 4;                  % Effectiveness contribution per hour of Y

int: fatigue_per_hour_X = 40;             % Fatigue cost per hour of X
int: fatigue_per_hour_Y = 60;             % Fatigue cost per hour of Y

int: max_diff_hours = 2;                  % Max allowed absolute difference between hours of X and Y

int: max_hours_X = 6;                     % Upper bound on hours of exercise X
int: max_hours_Y = 8;                     % Upper bound on hours of exercise Y


% Variables
var 0..max_hours_X: hours_X;              % Integer hours allocated to exercise X
var 0..max_hours_Y: hours_Y;              % Integer hours allocated to exercise Y

% Total fatigue score to minimize (bounded tightly enough to help propagation)
var 0..(fatigue_per_hour_X*max_hours_X + fatigue_per_hour_Y*max_hours_Y): total_fatigue;


% Constraints
% Total hours limit (time constraint)
constraint hours_X + hours_Y <= total_hours_limit;

% Minimum effectiveness requirement
constraint eff_per_hour_X * hours_X + eff_per_hour_Y * hours_Y >= effectiveness_min;

% Balanced training: absolute difference between hours does not exceed max_diff_hours
constraint abs(hours_X - hours_Y) <= max_diff_hours;

% Define total fatigue from chosen hours
constraint total_fatigue = fatigue_per_hour_X * hours_X + fatigue_per_hour_Y * hours_Y;


% Objective
solve minimize total_fatigue;