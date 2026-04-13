% Parameters
% Resource requirements (units) per division
int: req_X = 500;
int: req_Y = 400;
int: req_Z = 700;

% Total available resources (budget cap)
int: budget = 1000;

% Strategic guideline thresholds
int: min_diff_2X_minus_Y = 200;  % 2*X - Y >= 200
int: min_diff_Z_minus_Y = 50;    % Z - Y >= 50

% A safe upper bound for any single division allocation (cannot exceed total budget)
int: max_alloc = budget;


% Variables
% Integer allocations to each division (whole units)
var 0..max_alloc: alloc_X;  % allocated units to division X
var 0..max_alloc: alloc_Y;  % allocated units to division Y
var 0..max_alloc: alloc_Z;  % allocated units to division Z

% Total allocated support (objective to minimize)
var 0..budget: total_support;


% Constraints
% Total support definition (linking variable)
constraint
  total_support = alloc_X + alloc_Y + alloc_Z;

% Budget cap: combined allocation cannot exceed available resources
constraint
  alloc_X + alloc_Y + alloc_Z <= budget;

% Strategic guideline: twice allocation to X minus allocation to Y must be at least threshold
constraint
  2 * alloc_X - alloc_Y >= min_diff_2X_minus_Y;

% Strategic guideline: allocation to Z must exceed allocation to Y by at least threshold
constraint
  alloc_Z - alloc_Y >= min_diff_Z_minus_Y;


% Objective
solve minimize total_support;