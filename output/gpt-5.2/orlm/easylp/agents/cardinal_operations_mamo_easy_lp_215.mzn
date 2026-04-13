% Parameters
int: cost_X = 5;              % Cost per unit for Purchasing (X)
int: cost_Y = 3;              % Cost per unit for Sales (Y)
int: cost_Z = 4;              % Cost per unit for Logistics (Z)

int: max_X = 500;             % Maximum allocation for X
int: max_Y = 300;             % Maximum allocation for Y
int: max_Z = 200;             % Maximum allocation for Z

int: max_XY = 1000;           % Budget limit: X + Y <= 1000
int: max_YZ = 800;            % Manpower limit: Y + Z <= 800
int: min_diff_XZ = 200;       % Balance constraint: |X - Z| >= 200

% Variables
var 0..max_X: X;              % Units allocated to Purchasing
var 0..max_Y: Y;              % Units allocated to Sales
var 0..max_Z: Z;              % Units allocated to Logistics

% Upper bound on total cost based on max allocations
var 0..(cost_X*max_X + cost_Y*max_Y + cost_Z*max_Z): total_cost;

% Constraints
% --- Capacity / resource limit constraints ---
constraint X + Y <= max_XY;   % Budget limit for Purchasing + Sales
constraint Y + Z <= max_YZ;   % Manpower limit for Sales + Logistics

% --- Balance constraint between Purchasing and Logistics ---
constraint abs(X - Z) >= min_diff_XZ;  % Ensure allocations differ by at least min_diff_XZ

% --- Total cost calculation constraint ---
constraint total_cost = cost_X * X + cost_Y * Y + cost_Z * Z;

% Objective
solve minimize total_cost;