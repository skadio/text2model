% Parameters
% Fatigue score per hour for each group
int: fatigue_X = 2;
int: fatigue_Y = 3;

% Weekly training constraints
int: max_total_hours = 100;        % X + Y <= 100
int: min_diff_X_over_Y = 10;       % X >= Y + 10
int: min_fitness_requirement = 60; % 2X + Y >= 60

% Variables
var 0..max_total_hours: hours_X;   % integer hours for stamina building (group X)
var 0..max_total_hours: hours_Y;   % integer hours for skill development (group Y)
var 0..(fatigue_X*max_total_hours + fatigue_Y*max_total_hours): total_fatigue; % objective value

% Constraints
% Total fatigue definition (link objective variable to decision variables)
constraint total_fatigue = fatigue_X * hours_X + fatigue_Y * hours_Y;

% Facility/trainer capacity: total weekly training hours limit
constraint hours_X + hours_Y <= max_total_hours;

% Balanced program: stamina (X) must be at least 10 more hours than skills (Y)
constraint hours_X >= hours_Y + min_diff_X_over_Y;

% Minimum fitness standards: ensure enough combined training intensity
constraint 2 * hours_X + hours_Y >= min_fitness_requirement;

% Objective
solve minimize total_fatigue;