% Parameters
int: capacity = 1000;                 % Total production capacity (units)
int: demand_min = 300;                % Minimum required level for 2*X + Y
int: material_max = 600;              % Maximum allowed for X + 3*Z

int: costX = 50;                      % Unit cost of product X
int: costY = 30;                      % Unit cost of product Y
int: costZ = 20;                      % Unit cost of product Z

% Variables
var 0..capacity: x;                   % Units produced of product X
var 0..capacity: y;                   % Units produced of product Y
var 0..capacity: z;                   % Units produced of product Z

var 0..(costX*capacity + costY*capacity + costZ*capacity): total_cost; % Total cost (to minimize)

% Constraints
%--- Capacity constraint: total production cannot exceed available capacity
constraint
  x + y + z <= capacity;

%--- Demand constraint: ensure minimum market demand level is met for 2*X + Y
constraint
  2 * x + y >= demand_min;

%--- Material/operational constraint: limit on X + 3*Z usage
constraint
  x + 3 * z <= material_max;

%--- Cost definition constraint: link total_cost to production quantities and unit costs
constraint
  total_cost = costX * x + costY * y + costZ * z;

% Objective
solve minimize total_cost;