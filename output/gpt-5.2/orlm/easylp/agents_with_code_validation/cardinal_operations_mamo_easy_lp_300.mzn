% Parameters
% Unit costs ($ per unit resource) for each project
int: cost_x = 50;
int: cost_y = 60;
int: cost_z = 70;

% Resource allocation bounds (inclusive)
int: x_lb = 0;
int: x_ub = 200;
int: y_lb = 0;
int: y_ub = 150;
int: z_lb = 0;
int: z_ub = 300;

% Constraint RHS values
int: rhs_min_1 = 500;  % 2x + 3y + z >= 500
int: rhs_max_2 = 800;  % x + y + 4z <= 800
int: rhs_min_3 = 100;  % x - y + z >= 100


% Variables
var x_lb..x_ub: x;  % resource units allocated to project X
var y_lb..y_ub: y;  % resource units allocated to project Y
var z_lb..z_ub: z;  % resource units allocated to project Z

% Total cost (bounded for stronger propagation)
var 0..(cost_x*x_ub + cost_y*y_ub + cost_z*z_ub): total_cost;

% Link total cost to decision variables
constraint total_cost = cost_x * x + cost_y * y + cost_z * z;


% Constraints
% --- Feasibility constraints from problem statement ---

% Minimum combined allocation requirement: 2x + 3y + z >= 500
constraint 2 * x + 3 * y + z >= rhs_min_1;

% Maximum combined allocation requirement: x + y + 4z <= 800
constraint x + y + 4 * z <= rhs_max_2;

% Strategic difference requirement: x - y + z >= 100
constraint x - y + z >= rhs_min_3;


% Objective
solve minimize total_cost;