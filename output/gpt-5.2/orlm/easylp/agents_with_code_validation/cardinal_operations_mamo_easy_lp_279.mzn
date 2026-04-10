% Parameters
% All data is embedded directly in the model (no .dzn file expected).
int: capacity = 50;                  % Max total tourists allowed
int: costX = 150;                    % Cost per tourist in package X
int: costY = 200;                    % Cost per tourist in package Y
int: costZ = 100;                    % Cost per tourist in package Z
int: min_efficiency = 60;            % Minimum required efficiency score
int: max_diff_YZ = 10;               % Max allowed absolute difference between Y and Z

% Variables
var 0..capacity: x;                  % Tourists assigned to package X
var 0..capacity: y;                  % Tourists assigned to package Y
var 0..capacity: z;                  % Tourists assigned to package Z

% Total cost (upper bound: all tourists in the most expensive package)
var 0..(capacity * max([costX, costY, costZ])): total_cost;

% Constraints
% Capacity constraint
constraint x + y + z <= capacity;

% Minimum operational efficiency requirement
constraint 2*x + 3*y + z >= min_efficiency;

% Balanced distribution constraint between packages Y and Z
constraint abs(y - z) <= max_diff_YZ;

% Define total cost
constraint total_cost = costX*x + costY*y + costZ*z;

% Objective
solve minimize total_cost;