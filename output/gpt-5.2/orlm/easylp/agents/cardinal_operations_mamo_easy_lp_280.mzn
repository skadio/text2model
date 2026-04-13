% Parameters
int: capacity_total = 1000;              % Total capacity across all attractions
int: min_tourists_X = 200;               % Minimum tourists required for attraction X
int: min_tourists_Y = 150;               % Minimum tourists required for attraction Y
int: min_tourists_Z = 100;               % Minimum tourists required for attraction Z

int: revenue_per_tourist_X = 500;        % Revenue per tourist for X (dollars)
int: revenue_per_tourist_Y = 300;        % Revenue per tourist for Y (dollars)
int: revenue_per_tourist_Z = 200;        % Revenue per tourist for Z (dollars)

% Variables
var min_tourists_X..capacity_total: tourists_X;  % Tourists allocated to X
var min_tourists_Y..capacity_total: tourists_Y;  % Tourists allocated to Y
var min_tourists_Z..capacity_total: tourists_Z;  % Tourists allocated to Z

var 0..(revenue_per_tourist_X*capacity_total
      + revenue_per_tourist_Y*capacity_total
      + revenue_per_tourist_Z*capacity_total): total_revenue; % Total revenue

% Constraints
% Capacity constraint: total tourists across all attractions cannot exceed overall capacity
constraint
  tourists_X + tourists_Y + tourists_Z <= capacity_total;

% Revenue definition constraint: total revenue equals sum of per-attraction revenues
constraint
  total_revenue =
    revenue_per_tourist_X * tourists_X +
    revenue_per_tourist_Y * tourists_Y +
    revenue_per_tourist_Z * tourists_Z;

% Objective
solve maximize total_revenue;