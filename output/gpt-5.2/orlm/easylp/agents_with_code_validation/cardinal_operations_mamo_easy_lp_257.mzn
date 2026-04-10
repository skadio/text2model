% Parameters
int: total_capacity = 5000;              % Max total resources across X,Y,Z
int: min_xy_total  = 2000;               % Minimum resources allocated to X+Y
int: max_yz_total  = 2500;               % Maximum resources allocated to Y+Z

int: cost_x = 50;                        % Cost per unit at location X
int: cost_y = 30;                        % Cost per unit at location Y
int: cost_z = 20;                        % Cost per unit at location Z

% Variables
var 0..total_capacity: x;                % Units allocated to location X (integer, nonnegative)
var 0..total_capacity: y;                % Units allocated to location Y (integer, nonnegative)
var 0..total_capacity: z;                % Units allocated to location Z (integer, nonnegative)

var 0..(cost_x*total_capacity + cost_y*total_capacity + cost_z*total_capacity): total_cost;
                                         % Total cost (bounded linear expression)

% Constraints
% Total capacity limit across all locations
constraint x + y + z <= total_capacity;

% Demand / allocation requirement for X and Y combined
constraint x + y >= min_xy_total;

% Relationship between X and Y allocations: X must be twice Y
constraint x = 2 * y;

% Upper bound on combined allocations to Y and Z
constraint y + z <= max_yz_total;

% Define total cost from per-unit costs at each location
constraint total_cost = cost_x * x + cost_y * y + cost_z * z;

% Objective
solve minimize total_cost;

% Optional output for clarity
output [
  "x=", show(x), " y=", show(y), " z=", show(z), "\n",
  "total_cost=", show(total_cost), "\n"
];