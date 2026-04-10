% Parameters
int: max_total_hires = 100;              % Total hires cannot exceed this
int: min_hires_X = 20;                  % Minimum required hires for department X
int: min_hires_Y = 30;                  % Minimum required hires for department Y
int: min_hires_Z = 10;                  % Minimum required hires for department Z

int: cost_X = 50000;                    % Cost per hire in department X (dollars)
int: cost_Y = 60000;                    % Cost per hire in department Y (dollars)
int: cost_Z = 70000;                    % Cost per hire in department Z (dollars)

% Variables
var 0..max_total_hires: hires_X;         % Number of hires in department X (integer)
var 0..max_total_hires: hires_Y;         % Number of hires in department Y (integer)
var 0..max_total_hires: hires_Z;         % Number of hires in department Z (integer)

% Upper bound: max_total_hires * max(cost_X, cost_Y, cost_Z)
var 0..(max_total_hires * max(cost_X, max(cost_Y, cost_Z))): total_cost;

% Constraints
% Total hires must not exceed the allowed maximum
constraint hires_X + hires_Y + hires_Z <= max_total_hires;

% Department minimum hiring requirements
constraint hires_X >= min_hires_X;
constraint hires_Y >= min_hires_Y;
constraint hires_Z >= min_hires_Z;

% Define total cost from per-department hires and costs
constraint total_cost = cost_X * hires_X + cost_Y * hires_Y + cost_Z * hires_Z;

% Objective
solve minimize total_cost;

output [
  "hires_X = ", show(hires_X), "\n",
  "hires_Y = ", show(hires_Y), "\n",
  "hires_Z = ", show(hires_Z), "\n",
  "total_cost = $", show(total_cost), "\n"
];