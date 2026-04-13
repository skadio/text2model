% Parameters
% All data is embedded directly in the model (no .dzn file).
int: capacity_total = 100;          % Total allocation across X,Y,Z cannot exceed this
int: min_diff_XY = 10;              % X must be at least this many units more than Y
int: capacity_YZ = 70;              % Y + Z cannot exceed this

int: cost_X = 5;                    % Cost per unit on route X
int: cost_Y = 3;                    % Cost per unit on route Y
int: cost_Z = 4;                    % Cost per unit on route Z

% Variables
var 0..capacity_total: x;           % Integer units allocated to route X
var 0..capacity_total: y;           % Integer units allocated to route Y
var 0..capacity_total: z;           % Integer units allocated to route Z

% Total cost (bounded for solver efficiency)
var 0..(cost_X*capacity_total + cost_Y*capacity_total + cost_Z*capacity_total): total_cost;

% Constraints
% Total allocation capacity across all routes
constraint x + y + z <= capacity_total;

% Balance requirement: route X must exceed route Y by at least min_diff_XY
constraint x >= y + min_diff_XY;

% Joint capacity limit for routes Y and Z
constraint y + z <= capacity_YZ;

% Define total cost from per-unit costs
constraint total_cost = cost_X * x + cost_Y * y + cost_Z * z;

% Objective
solve minimize total_cost;

% Optional output
output [
  "x=", show(x), " y=", show(y), " z=", show(z), " total_cost=", show(total_cost), "\n"
];