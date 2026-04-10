% Parameters
int: total_employees = 100;                 % Total number of new employees to allocate

int: min_X = 20;                            % Minimum hires required in department X
int: min_Y = 15;                            % Minimum hires required in department Y
int: min_Z = 10;                            % Minimum hires required in department Z

int: cost_X = 50;                           % Training cost per hire in department X
int: cost_Y = 80;                           % Training cost per hire in department Y
int: cost_Z = 30;                           % Training cost per hire in department Z

% Variables
var 0..total_employees: hires_X;            % Number of hires allocated to department X
var 0..total_employees: hires_Y;            % Number of hires allocated to department Y
var 0..total_employees: hires_Z;            % Number of hires allocated to department Z

% Upper bound uses the maximum possible per-hire cost
var 0..(total_employees * max([cost_X, cost_Y, cost_Z])): total_training_cost;

% Constraints
% Employee allocation must sum to the total number of employees
constraint hires_X + hires_Y + hires_Z = total_employees;

% Minimum staffing requirements per department
constraint hires_X >= min_X;
constraint hires_Y >= min_Y;
constraint hires_Z >= min_Z;

% Define total training cost from per-department costs and hires
constraint total_training_cost =
    cost_X * hires_X + cost_Y * hires_Y + cost_Z * hires_Z;

% Objective
solve minimize total_training_cost;