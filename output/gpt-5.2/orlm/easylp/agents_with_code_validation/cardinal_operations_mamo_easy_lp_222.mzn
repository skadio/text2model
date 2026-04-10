% Parameters
% Total available space in the store (square meters)
int: total_space = 1000;

% Minimum required space for each product type (square meters)
int: min_space_X = 200;
int: min_space_Y = 150;
int: min_space_Z = 100;

% Cost (or revenue coefficient as given) per square meter ($/m^2)
int: cost_per_sqm_X = 5;
int: cost_per_sqm_Y = 3;
int: cost_per_sqm_Z = 2;


% Variables
% Allocated space for each product type (whole square meters)
var 0..total_space: space_X;
var 0..total_space: space_Y;
var 0..total_space: space_Z;

% Total cost (bounded above by allocating all space at max unit cost)
var 0..(total_space * max([cost_per_sqm_X, cost_per_sqm_Y, cost_per_sqm_Z])): total_cost;


% Constraints
%--- Minimum space requirements for each product type ---
constraint space_X >= min_space_X;
constraint space_Y >= min_space_Y;
constraint space_Z >= min_space_Z;

%--- Total available store space limit ---
constraint space_X + space_Y + space_Z <= total_space;

%--- Define total cost from allocated spaces and per-sqm costs ---
constraint total_cost =
  cost_per_sqm_X * space_X +
  cost_per_sqm_Y * space_Y +
  cost_per_sqm_Z * space_Z;


% Objective
solve minimize total_cost;