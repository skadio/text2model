% Parameters
int: capacity = 1000;                 % Maximum total units producible
int: demand_X2_plus_Y = 500;          % Minimum required for 2*X + Y
int: inventory_X_plus_Z = 400;        % Minimum required for X + Z

int: cost_X = 2;                      % Unit cost of product X
int: cost_Y = 3;                      % Unit cost of product Y
int: cost_Z = 4;                      % Unit cost of product Z

% Variables
var 0..capacity: X;                   % Units of product X (integer, non-negative, capacity-bounded)
var 0..capacity: Y;                   % Units of product Y (integer, non-negative, capacity-bounded)
var 0..capacity: Z;                   % Units of product Z (integer, non-negative, capacity-bounded)

% Upper bound uses worst-case cost if all capacity were spent on each product (safe loose bound)
var 0..(cost_X*capacity + cost_Y*capacity + cost_Z*capacity): total_cost; % Total production cost

% Constraints
% Capacity constraint: total production cannot exceed available capacity
constraint
  X + Y + Z <= capacity;

% Demand fulfillment: complexity-weighted demand for X and Y
constraint
  2 * X + Y >= demand_X2_plus_Y;

% Inventory balance: ensure minimum combined production of X and Z
constraint
  X + Z >= inventory_X_plus_Z;

% Cost accounting: define total cost from unit costs and production quantities
constraint
  total_cost = cost_X * X + cost_Y * Y + cost_Z * Z;

% Objective
solve minimize total_cost;