% Parameters
int: max_total_production = 500;              % Maximum combined production capacity
int: min_demand_constraint1 = 200;            % Minimum for (2*X + Y)
int: min_demand_constraint2 = 150;            % Minimum for (Y + Z)

int: cost_x = 50;                             % Unit cost for product X
int: cost_y = 60;                             % Unit cost for product Y
int: cost_z = 20;                             % Unit cost for product Z

int: x_lb = 0; int: x_ub = 300;               % Bounds for X production
int: y_lb = 0; int: y_ub = 200;               % Bounds for Y production
int: z_lb = 0; int: z_ub = 100;               % Bounds for Z production

% Variables
var x_lb..x_ub: x;                            % Production quantity of X (integer units)
var y_lb..y_ub: y;                            % Production quantity of Y (integer units)
var z_lb..z_ub: z;                            % Production quantity of Z (integer units)

var 0..(cost_x*x_ub + cost_y*y_ub + cost_z*z_ub): total_cost;  % Total cost (bounded)

% Constraints
% Total production capacity constraint (combined production cannot exceed capacity)
constraint
  x + y + z <= max_total_production;

% Demand constraint 1: ensure sufficient production weighted by product X
constraint
  2 * x + y >= min_demand_constraint1;

% Demand constraint 2: ensure sufficient combined production of products Y and Z
constraint
  y + z >= min_demand_constraint2;

% Total cost definition constraint (link total_cost to decision variables)
constraint
  total_cost = cost_x * x + cost_y * y + cost_z * z;

% Objective
solve minimize total_cost;