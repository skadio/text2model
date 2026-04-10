% Parameters
% All data is embedded directly in the model (no .dzn expected)

int: min_XY = 1000;          % Minimum required allocation for X+Y
int: max_YZ_diff = 500;      % Maximum allowed absolute difference |Y - Z|
int: eq_XZ = 1500;           % Required exact allocation for X+Z

int: cost_X = 8;             % Unit cost for project X
int: cost_Y = 5;             % Unit cost for project Y
int: cost_Z = 2;             % Unit cost for project Z

% Safe upper bound for X and Z from X+Z = 1500 with nonnegativity
int: UB_alloc = eq_XZ;

% Variables
var 0..UB_alloc: X;                    % Integer allocation to project X
var 0..(min_XY + UB_alloc): Y;         % Integer allocation to project Y (safe bound)
var 0..UB_alloc: Z;                    % Integer allocation to project Z

var 0..(cost_X*UB_alloc + cost_Y*(min_XY + UB_alloc) + cost_Z*UB_alloc): total_cost;
var 0..max_YZ_diff: yz_diff;           % Represents |Y - Z|

% Constraints
% --- Minimum allocation requirement for projects X and Y ---
constraint X + Y >= min_XY;

% --- Exact combined allocation requirement for projects X and Z ---
constraint X + Z = eq_XZ;

% --- Balanced portfolio: enforce yz_diff = |Y - Z| and bound it by max_YZ_diff ---
constraint yz_diff >= Y - Z;
constraint yz_diff >= Z - Y;
constraint yz_diff <= max_YZ_diff;

% --- Total cost definition from unit costs and allocations ---
constraint total_cost = cost_X * X + cost_Y * Y + cost_Z * Z;

% Objective
solve minimize total_cost;