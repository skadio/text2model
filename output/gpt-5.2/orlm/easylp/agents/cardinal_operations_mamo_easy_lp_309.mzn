% Parameters
int: max_total_resources = 100;         % Maximum total units deployable (X+Y+Z)
int: min_req_xy = 50;                  % Minimum required strength for 2*X + 1*Y
int: min_req_xz = 40;                  % Minimum required strength for 1*X + 1*Z

int: cost_x = 5000;                    % Cost per unit of X
int: cost_y = 4000;                    % Cost per unit of Y
int: cost_z = 6000;                    % Cost per unit of Z

% Variables
var 0..max_total_resources: x;          % Number of units deployed to unit X
var 0..max_total_resources: y;          % Number of units deployed to unit Y
var 0..max_total_resources: z;          % Number of units deployed to unit Z

% Upper bound: all resources assigned to the most expensive unit
var 0..(max_total_resources * max(cost_x, max(cost_y, cost_z))): total_cost;

% Constraints
% Total resources limit (logistical constraint)
constraint x + y + z <= max_total_resources;

% Minimum combined strength requirement for units X and Y: 2*X + Y >= min_req_xy
constraint 2 * x + y >= min_req_xy;

% Minimum combined strength requirement for units X and Z: X + Z >= min_req_xz
constraint x + z >= min_req_xz;

% Define total cost based on deployed units and per-unit costs
constraint total_cost = cost_x * x + cost_y * y + cost_z * z;

% Objective
solve minimize total_cost;

% Optional output for inspection
output [
  "x=", show(x), " y=", show(y), " z=", show(z), "\n",
  "total_cost=", show(total_cost), "\n"
];