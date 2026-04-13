% Parameters
int: cost_x = 50;              % Cost per container of type X (USD)
int: cost_y = 70;              % Cost per container of type Y (USD)
int: max_total = 1000;         % Maximum total containers per trip
int: min_x = 300;              % Minimum required containers of type X
int: min_y = 200;              % Minimum required containers of type Y

% Variables
var min_x..max_total: x;       % Number of type X containers shipped (integer)
var min_y..max_total: y;       % Number of type Y containers shipped (integer)
var 0..(cost_x*max_total + cost_y*max_total): total_cost;  % Total shipping cost (USD)

% Constraints
% Link total_cost to the number of containers shipped of each type
constraint
  total_cost = cost_x * x + cost_y * y;

% Ship capacity constraint: cannot exceed maximum total containers per trip
constraint
  x + y <= max_total;

% Contractual minimum shipment constraints (redundant with variable domains but kept for clarity)
constraint
  x >= min_x;

constraint
  y >= min_y;

% Objective
solve minimize total_cost;