% Parameters
% All data is embedded directly in the model (no .dzn expected).
int: max_total_hours = 50;            % Total hours limit: X + Y <= 50
int: min_effectiveness = 20;          % Minimum effectiveness: 2*X + 1*Y >= 20
int: diff_limit = 10;                 % Balance constraint: |X - 3*Y| <= 10

int: eff_x = 2;                       % Effectiveness per hour of X
int: eff_y = 1;                       % Effectiveness per hour of Y
int: fatigue_x = 5;                   % Fatigue cost per hour of X
int: fatigue_y = 3;                   % Fatigue cost per hour of Y


% Variables
var 0..max_total_hours: hours_x;      % Integer hours assigned to workout X
var 0..max_total_hours: hours_y;      % Integer hours assigned to workout Y

var 0..(fatigue_x*max_total_hours + fatigue_y*max_total_hours): total_fatigue;
                                      % Total fatigue cost to minimize


% Constraints
% Total training hours limit: X + Y <= 50
constraint hours_x + hours_y <= max_total_hours;

% Minimum effectiveness requirement: eff_x*X + eff_y*Y >= 20
constraint eff_x * hours_x + eff_y * hours_y >= min_effectiveness;

% Balanced training schedule: |X - 3*Y| <= 10
constraint abs(hours_x - 3 * hours_y) <= diff_limit;

% Define total fatigue cost from chosen hours
constraint total_fatigue = fatigue_x * hours_x + fatigue_y * hours_y;


% Objective
solve minimize total_fatigue;