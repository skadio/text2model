% Parameters
int: water_per_x = 5;          % water required per unit of crop X
int: water_per_y = 3;          % water required per unit of crop Y
int: water_available = 100;    % total water available

int: yield_coeff_x = 2;        % yield coefficient for X in the balanced harvest constraint
int: yield_coeff_y = 1;        % yield coefficient for Y in the balanced harvest constraint
int: min_yield = 30;           % minimum required combined yield

int: cost_per_x = 4;           % cost per unit of crop X
int: cost_per_y = 2;           % cost per unit of crop Y

% Derived safe upper bounds (from water constraint)
int: max_x = water_available div water_per_x;  % maximum feasible units of X by water alone
int: max_y = water_available div water_per_y;  % maximum feasible units of Y by water alone


% Variables
var 0..max_x: x_units;         % integer units of crop X to plant
var 0..max_y: y_units;         % integer units of crop Y to plant

var 0..(cost_per_x*max_x + cost_per_y*max_y): total_cost; % total cost to minimize


% Constraints

% Water capacity constraint: total water used by crops X and Y cannot exceed available water
constraint
  water_per_x * x_units + water_per_y * y_units <= water_available;

% Balanced harvest (minimum yield) constraint: ensure combined yield meets the minimum requirement
constraint
  yield_coeff_x * x_units + yield_coeff_y * y_units >= min_yield;

% Total cost definition constraint: link total_cost to chosen units of X and Y
constraint
  total_cost = cost_per_x * x_units + cost_per_y * y_units;


% Objective
solve minimize total_cost;