% Parameters
int: max_total_hires = 100;          % Budget-driven upper bound on total hires

int: min_hires_X = 20;              % Minimum hires required for department X
int: min_hires_Y = 30;              % Minimum hires required for department Y
int: min_hires_Z = 10;              % Minimum hires required for department Z

int: cost_X = 50000;                % Cost per hire in department X (dollars)
int: cost_Y = 60000;                % Cost per hire in department Y (dollars)
int: cost_Z = 70000;                % Cost per hire in department Z (dollars)

% Variables
var min_hires_X..max_total_hires: hires_X;   % Number of hires in department X (integer)
var min_hires_Y..max_total_hires: hires_Y;   % Number of hires in department Y (integer)
var min_hires_Z..max_total_hires: hires_Z;   % Number of hires in department Z (integer)

var 0..(cost_X*max_total_hires + cost_Y*max_total_hires + cost_Z*max_total_hires): total_cost;
% Total hiring cost (dollars, integer)

% Constraints
% Minimum hires per department (also enforced by variable domains)
constraint hires_X >= min_hires_X;
constraint hires_Y >= min_hires_Y;
constraint hires_Z >= min_hires_Z;

% Total hires cannot exceed the maximum allowed
constraint hires_X + hires_Y + hires_Z <= max_total_hires;

% Total cost definition
constraint total_cost = cost_X * hires_X + cost_Y * hires_Y + cost_Z * hires_Z;

% Objective
solve minimize total_cost;