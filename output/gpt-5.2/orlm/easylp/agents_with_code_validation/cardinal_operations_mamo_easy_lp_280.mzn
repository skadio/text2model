% Parameters
int: max_total_tourists = 1000;          % Total capacity across all attractions
int: min_tourists_X     = 200;           % Minimum tourists required for attraction X
int: min_tourists_Y     = 150;           % Minimum tourists required for attraction Y
int: min_tourists_Z     = 100;           % Minimum tourists required for attraction Z

int: revenue_per_X = 500;               % Revenue per tourist for X (dollars)
int: revenue_per_Y = 300;               % Revenue per tourist for Y (dollars)
int: revenue_per_Z = 200;               % Revenue per tourist for Z (dollars)

% Variables
var 0..max_total_tourists: tourists_X;   % Number of tourists allocated to X (integer)
var 0..max_total_tourists: tourists_Y;   % Number of tourists allocated to Y (integer)
var 0..max_total_tourists: tourists_Z;   % Number of tourists allocated to Z (integer)

var 0..(max_total_tourists * max(revenue_per_X, max(revenue_per_Y, revenue_per_Z))): total_revenue;
% Total revenue (dollars), bounded above by max possible

% Constraints
% Minimum operating levels for each attraction
constraint tourists_X >= min_tourists_X;
constraint tourists_Y >= min_tourists_Y;
constraint tourists_Z >= min_tourists_Z;

% Total capacity across all attractions
constraint tourists_X + tourists_Y + tourists_Z <= max_total_tourists;

% Define total revenue from allocations
constraint total_revenue =
    revenue_per_X * tourists_X +
    revenue_per_Y * tourists_Y +
    revenue_per_Z * tourists_Z;

% Objective
solve maximize total_revenue;