% Parameters
int: max_total_tourists = 50;          % Maximum allowed tourists across all trips

int: min_tourists_X = 10;             % Minimum tourists for trip X
int: min_tourists_Y = 5;              % Minimum tourists for trip Y
int: min_tourists_Z = 8;              % Minimum tourists for trip Z

int: cost_per_tourist_X = 100;        % Cost per tourist for trip X ($)
int: cost_per_tourist_Y = 80;         % Cost per tourist for trip Y ($)
int: cost_per_tourist_Z = 150;        % Cost per tourist for trip Z ($)

% Variables
var 0..max_total_tourists: tourists_X; % Number of tourists in trip X
var 0..max_total_tourists: tourists_Y; % Number of tourists in trip Y
var 0..max_total_tourists: tourists_Z; % Number of tourists in trip Z

var 0..(max_total_tourists * max([cost_per_tourist_X, cost_per_tourist_Y, cost_per_tourist_Z])): total_cost;
% Total cost ($), upper-bounded for linear optimization

% Constraints
% Minimum tourists required for each trip (viability constraints)
constraint tourists_X >= min_tourists_X;
constraint tourists_Y >= min_tourists_Y;
constraint tourists_Z >= min_tourists_Z;

% Total tourists across all trips cannot exceed the allowed maximum
constraint tourists_X + tourists_Y + tourists_Z <= max_total_tourists;

% Define total cost as the sum of per-trip costs
constraint total_cost =
    cost_per_tourist_X * tourists_X +
    cost_per_tourist_Y * tourists_Y +
    cost_per_tourist_Z * tourists_Z;

% Objective
solve minimize total_cost;