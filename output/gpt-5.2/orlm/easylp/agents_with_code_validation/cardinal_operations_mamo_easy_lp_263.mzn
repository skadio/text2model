% Parameters
int: cost_X = 5000;          % Cost per hire in department X
int: cost_Y = 7000;          % Cost per hire in department Y
int: cost_Z = 10000;         % Cost per hire in department Z

int: max_total_hires = 50;   % Maximum total hires across all departments
int: min_hires_X = 10;       % Minimum hires required in department X
int: min_hires_Y = 15;       % Minimum hires required in department Y
int: min_hires_Z = 20;       % Minimum hires required in department Z

% Variables
var min_hires_X..max_total_hires: hires_X;  % Number of hires in department X
var min_hires_Y..max_total_hires: hires_Y;  % Number of hires in department Y
var min_hires_Z..max_total_hires: hires_Z;  % Number of hires in department Z

% Total hiring cost (upper bound assumes all 50 hires could be in each dept, safe but loose)
var 0..(cost_X*max_total_hires + cost_Y*max_total_hires + cost_Z*max_total_hires): total_cost;

% Constraints
% Meet minimum hires for each department (redundant due to variable lower bounds, kept for clarity)
constraint hires_X >= min_hires_X;
constraint hires_Y >= min_hires_Y;
constraint hires_Z >= min_hires_Z;

% Total hires cannot exceed the maximum allowed
constraint hires_X + hires_Y + hires_Z <= max_total_hires;

% Define total cost from per-department hiring costs
constraint total_cost = cost_X * hires_X + cost_Y * hires_Y + cost_Z * hires_Z;

% Objective
solve minimize total_cost;