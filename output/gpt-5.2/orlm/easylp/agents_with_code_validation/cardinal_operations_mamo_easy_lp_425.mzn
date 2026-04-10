% Parameters
int: capacity = 300;                 % Maximum total units produced (X + Y)
int: demand_x_coeff = 3;             % Coefficient of X in demand constraint
int: demand_y_coeff = 4;             % Coefficient of Y in demand constraint
int: demand_min = 800;               % Minimum required combined output
int: cost_x = 50;                    % Unit cost of product X
int: cost_y = 70;                    % Unit cost of product Y

% Variables
var 0..capacity: x_units;            % Integer units of product X
var 0..capacity: y_units;            % Integer units of product Y
var 0..(cost_x*capacity + cost_y*capacity): total_cost;  % Total cost (bounded)

% Constraints
% Capacity constraint: total production cannot exceed factory capacity
constraint
  x_units + y_units <= capacity;

% Demand constraint: combined output of 3*X + 4*Y must meet minimum requirement
constraint
  demand_x_coeff * x_units + demand_y_coeff * y_units >= demand_min;

% Production mix constraint: maintain or increase quantity of X compared to Y
constraint
  x_units >= y_units;

% Total cost definition: compute total cost from unit costs and production quantities
constraint
  total_cost = cost_x * x_units + cost_y * y_units;

% Objective
solve minimize total_cost;