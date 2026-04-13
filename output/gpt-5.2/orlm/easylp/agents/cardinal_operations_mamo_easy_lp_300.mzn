% Parameters
% Unit costs ($ per unit resource) for projects X, Y, Z
int: cost_x = 50;
int: cost_y = 60;
int: cost_z = 70;

% Bounds on resource allocations (inclusive)
int: x_lb = 0;
int: x_ub = 200;
int: y_lb = 0;
int: y_ub = 150;
int: z_lb = 0;
int: z_ub = 300;

% Constraint RHS values
int: min_combo_1 = 500;   % for 2x + 3y + z >= 500
int: max_combo_2 = 800;   % for x + y + 4z <= 800
int: min_combo_3 = 100;   % for x - y + z >= 100

% Variables
% Integer allocations of resources to each project
var x_lb..x_ub: x;  % allocation to project X
var y_lb..y_ub: y;  % allocation to project Y
var z_lb..z_ub: z;  % allocation to project Z

% Total cost to minimize (explicitly bounded)
var 0..(cost_x*x_ub + cost_y*y_ub + cost_z*z_ub): total_cost;

% Constraints
% Link total_cost to the linear cost expression
constraint
  total_cost = cost_x * x + cost_y * y + cost_z * z;

% Minimum combined allocation requirement: 2x + 3y + z >= 500
constraint
  2 * x + 3 * y + z >= min_combo_1;

% Maximum combined allocation limit: x + y + 4z <= 800
constraint
  x + y + 4 * z <= max_combo_2;

% Strategic difference requirement: x - y + z >= 100
constraint
  x - y + z >= min_combo_3;

% Objective
solve minimize total_cost;