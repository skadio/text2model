% Parameters
% Budget limits and minimum spend requirements (all in dollars)
int: max_XY = 1000;     % X + Y cannot exceed this
int: max_YZ = 800;      % Y + Z cannot exceed this
int: min_XZ = 500;      % X + Z must be at least this

% Cost per unit for each channel (dollars per unit)
int: costX = 5;
int: costY = 4;
int: costZ = 3;

% Variables
% Spend in each channel (integer, non-negative)
var 0..max_XY: X;                       % safe bound since X + Y <= max_XY and Y >= 0
var 0..max(max_XY, max_YZ): Y;          % safe upper bound from given maxima
var 0..max_YZ: Z;                       % safe bound since Y + Z <= max_YZ and Y >= 0

% Total cost to minimize
var 0..(costX*max_XY + costY*max(max_XY, max_YZ) + costZ*max_YZ): total_cost;

% Constraints
% Budget cap constraints
constraint X + Y <= max_XY;
constraint Y + Z <= max_YZ;

% Minimum spend requirement
constraint X + Z >= min_XZ;

% Total cost definition
constraint total_cost = costX * X + costY * Y + costZ * Z;

% Objective
solve minimize total_cost;