% Parameters
% Fatigue score contribution per training hour
int: fatigue_per_hour_X = 2;          % Group X (stamina)
int: fatigue_per_hour_Y = 3;          % Group Y (skills)

% Weekly training policy/resource limits
int: max_total_hours = 100;           % X + Y cannot exceed this
int: min_diff_X_over_Y = 10;          % X must be at least 10 more than Y
int: min_fitness_requirement = 60;    % 2X + Y must be at least this

% Variables
% Decision variables: integer weekly hours for each group
var 0..max_total_hours: X;            % Stamina-building hours
var 0..max_total_hours: Y;            % Skill-development hours

% Objective variable: total fatigue score
var 0..(fatigue_per_hour_X*max_total_hours + fatigue_per_hour_Y*max_total_hours): total_fatigue;

% Constraints
% Capacity constraint: total training hours cannot exceed available resources
constraint X + Y <= max_total_hours;

% Balance constraint: stamina hours (X) must be at least 10 more than skill hours (Y)
constraint X >= Y + min_diff_X_over_Y;

% Minimum fitness constraint: ensure sufficient combined intensity of training
constraint 2 * X + Y >= min_fitness_requirement;

% Definition constraint: compute total fatigue from allocated hours
constraint total_fatigue = fatigue_per_hour_X * X + fatigue_per_hour_Y * Y;

% Objective
solve minimize total_fatigue;