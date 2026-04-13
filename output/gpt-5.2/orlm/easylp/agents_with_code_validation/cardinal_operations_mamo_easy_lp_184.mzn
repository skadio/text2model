% Parameters
int: capacity = 1000;                 % Maximum total production capacity
int: demand_min = 600;                % Minimum required for 3*X + 4*Y
int: balance_max = 200;               % Maximum allowed for 5*Z - Y

int: cost_x = 50;                     % Unit production cost of X
int: cost_y = 30;                     % Unit production cost of Y
int: cost_z = 20;                     % Unit production cost of Z

% Variables
var 0..capacity: prod_x;              % Integer units of product X
var 0..capacity: prod_y;              % Integer units of product Y
var 0..capacity: prod_z;              % Integer units of product Z

var 0..(cost_x*capacity + cost_y*capacity + cost_z*capacity): total_cost;
                                      % Total cost (bounded)

% Constraints
% Link derived variable total_cost to decision variables
constraint total_cost = cost_x*prod_x + cost_y*prod_y + cost_z*prod_z;

% Capacity constraint: total production cannot exceed factory capacity
constraint prod_x + prod_y + prod_z <= capacity;

% Demand constraint: ensure sufficient combined production of X and Y
constraint 3 * prod_x + 4 * prod_y >= demand_min;

% Balance constraint: maintain inventory balance between Z and Y
constraint 5 * prod_z - prod_y <= balance_max;

% Objective
solve minimize total_cost;