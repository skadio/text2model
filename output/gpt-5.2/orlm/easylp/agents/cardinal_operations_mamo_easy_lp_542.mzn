% Parameters
int: total_resource_cap = 100;              % Maximum total units across all projects

int: min_viability_XY = 30;                 % Minimum for 2*X + Y
int: min_viability_XZ = 40;                 % Minimum for X + Z

int: cost_X = 1000;                         % Cost per unit for Project X
int: cost_Y = 2000;                         % Cost per unit for Project Y
int: cost_Z = 3000;                         % Cost per unit for Project Z

int: X_lb = 0;  int: X_ub = 50;             % Bounds for Project X allocation
int: Y_lb = 0;  int: Y_ub = 60;             % Bounds for Project Y allocation
int: Z_lb = 0;  int: Z_ub = 70;             % Bounds for Project Z allocation


% Variables
var X_lb..X_ub: x;                          % Units allocated to Project X (integer)
var Y_lb..Y_ub: y;                          % Units allocated to Project Y (integer)
var Z_lb..Z_ub: z;                          % Units allocated to Project Z (integer)

% Upper bound is a safe worst-case bound based on per-project maxima
var 0..(cost_X*X_ub + cost_Y*Y_ub + cost_Z*Z_ub): total_cost;  % Total cost in dollars


% Constraints
% Total resource capacity across all projects
constraint x + y + z <= total_resource_cap;

% Viability constraint for Projects X and Y: 2*X + Y >= minimum required
constraint 2 * x + y >= min_viability_XY;

% Viability constraint for Projects X and Z: X + Z >= minimum required
constraint x + z >= min_viability_XZ;

% Define total cost from per-unit costs and allocations
constraint total_cost = cost_X * x + cost_Y * y + cost_Z * z;


% Objective
solve minimize total_cost;