% Parameters
int: total_space = 1000;                 % Total available space (square meters)
int: min_space_X = 200;                  % Minimum required space for product X
int: min_space_Y = 150;                  % Minimum required space for product Y
int: min_space_Z = 100;                  % Minimum required space for product Z
int: revenue_per_sqm_X = 5;              % Revenue per square meter for product X ($/sqm)
int: revenue_per_sqm_Y = 3;              % Revenue per square meter for product Y ($/sqm)
int: revenue_per_sqm_Z = 2;              % Revenue per square meter for product Z ($/sqm)

% Variables
var min_space_X..total_space: space_X;   % Allocated space to product X (integer sqm)
var min_space_Y..total_space: space_Y;   % Allocated space to product Y (integer sqm)
var min_space_Z..total_space: space_Z;   % Allocated space to product Z (integer sqm)

% Upper bound: worst case if all 1000 sqm allocated to each product (loose but safe)
var 0..(revenue_per_sqm_X*total_space + revenue_per_sqm_Y*total_space + revenue_per_sqm_Z*total_space): total_cost;
                                         % Total cost (interpreted from revenues), integer dollars

% Constraints
% Total space capacity constraint (cannot exceed available store space)
constraint
  space_X + space_Y + space_Z <= total_space;

% Minimum space requirements (redundant due to variable lower bounds, kept for clarity)
constraint space_X >= min_space_X;
constraint space_Y >= min_space_Y;
constraint space_Z >= min_space_Z;

% Total cost definition (interpreting "cost" as total revenue/cost expression from per-sqm values)
constraint
  total_cost =
    revenue_per_sqm_X * space_X +
    revenue_per_sqm_Y * space_Y +
    revenue_per_sqm_Z * space_Z;

% Objective
solve minimize total_cost;