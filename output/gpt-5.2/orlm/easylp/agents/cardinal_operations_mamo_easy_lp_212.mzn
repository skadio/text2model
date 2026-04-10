% Parameters
% Unit costs for allocating 1 unit of resource to each department
int: costX = 2;
int: costY = 3;
int: costZ = 1;

% Constraint thresholds
int: min_XY = 50;       % X + Y must be at least this value
int: max_XZ = 100;      % X + Z must be at most this value
int: min_YZ_diff = 10;  % Y - Z must be at least this value


% Variables
% Integer resource allocations (non-negative whole numbers)
var 0..1000: x; % resources allocated to department X
var 0..1000: y; % resources allocated to department Y
var 0..1000: z; % resources allocated to department Z

% Total cost to minimize
var 0..(costX*1000 + costY*1000 + costZ*1000): total_cost;


% Constraints
% Total cost definition (link decision variables to total_cost)
constraint total_cost = costX * x + costY * y + costZ * z;

% Minimum combined allocation for departments X and Y
constraint x + y >= min_XY;

% Maximum combined allocation for departments X and Z
constraint x + z <= max_XZ;

% Minimum required difference between departments Y and Z allocations
constraint y - z >= min_YZ_diff;


% Objective
solve minimize total_cost;