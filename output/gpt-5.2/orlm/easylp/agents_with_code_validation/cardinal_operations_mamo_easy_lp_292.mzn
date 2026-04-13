% Parameters
% (Embedded from problem description; no .dzn expected)
int: total_alloc_cap = 100;          % Total allocation cap: X+Y+Z <= 100
int: yz_alloc_cap = 70;              % Combined cap: Y+Z <= 70
int: x_min_over_2y = 10;             % Constraint: X >= 2*Y + 10

int: cost_x = 3;                     % Cost per unit for X
int: cost_y = 2;                     % Cost per unit for Y
int: cost_z = 5;                     % Cost per unit for Z

int: x_lb = 0; int: x_ub = 50;       % Bounds for X
int: y_lb = 0; int: y_ub = 30;       % Bounds for Y
int: z_lb = 0;                       % Lower bound for Z (no upper bound specified)

% Variables
var x_lb..x_ub: x_alloc;             % Integer allocation to Project X
var y_lb..y_ub: y_alloc;             % Integer allocation to Project Y
var z_lb..total_alloc_cap: z_alloc;  % Allocation to Project Z (bounded by total cap)

% Upper bound for total cost based on variable bounds
var 0..(cost_x*x_ub + cost_y*y_ub + cost_z*total_alloc_cap): total_cost;

% Constraints
%--- Allocation capacity constraints ---
constraint x_alloc + y_alloc + z_alloc <= total_alloc_cap;
constraint y_alloc + z_alloc <= yz_alloc_cap;

%--- Relative allocation constraint ---
constraint x_alloc >= 2 * y_alloc + x_min_over_2y;

%--- Cost accounting constraint ---
constraint total_cost = cost_x * x_alloc + cost_y * y_alloc + cost_z * z_alloc;

% Objective
solve minimize total_cost;