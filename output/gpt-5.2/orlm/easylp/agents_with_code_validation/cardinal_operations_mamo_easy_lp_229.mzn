% Parameters
int: total_resource_cap = 1000;      % Maximum total resources available
int: min_x = 200;                    % Minimum resources required for area X
int: min_y = 150;                    % Minimum resources required for area Y
int: min_z = 250;                    % Minimum resources required for area Z
int: cost_x = 10;                    % Cost per unit in area X (dollars)
int: cost_y = 15;                    % Cost per unit in area Y (dollars)
int: cost_z = 20;                    % Cost per unit in area Z (dollars)

% Variables
var min_x..total_resource_cap: X;    % Resources allocated to area X (integer)
var min_y..total_resource_cap: Y;    % Resources allocated to area Y (integer)
var min_z..total_resource_cap: Z;    % Resources allocated to area Z (integer)

% Safe upper bound: worst case (over-approx) if each variable could reach the cap
var 0..(cost_x*total_resource_cap + cost_y*total_resource_cap + cost_z*total_resource_cap): total_cost;

% Constraints
% Resource feasibility: respect the overall resource cap
constraint X + Y + Z <= total_resource_cap;

% Minimum allocation requirements (redundant due to variable domains, kept for clarity)
constraint X >= min_x;
constraint Y >= min_y;
constraint Z >= min_z;

% Total cost definition
constraint total_cost = cost_x * X + cost_y * Y + cost_z * Z;

% Objective
solve minimize total_cost;