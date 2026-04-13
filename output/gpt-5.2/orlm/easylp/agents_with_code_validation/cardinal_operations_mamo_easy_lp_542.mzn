% Parameters
int: total_capacity = 100;                 % Total resources available across all projects

int: min_2x_plus_y = 30;                   % Minimum requirement for 2*X + Y
int: min_x_plus_z  = 40;                   % Minimum requirement for X + Z

int: cost_x = 1000;                        % Cost per unit for Project X
int: cost_y = 2000;                        % Cost per unit for Project Y
int: cost_z = 3000;                        % Cost per unit for Project Z

int: x_lb = 0; int: x_ub = 50;             % Bounds for allocation to Project X
int: y_lb = 0; int: y_ub = 60;             % Bounds for allocation to Project Y
int: z_lb = 0; int: z_ub = 70;             % Bounds for allocation to Project Z


% Variables
var x_lb..x_ub: x;                         % Integer resources allocated to Project X
var y_lb..y_ub: y;                         % Integer resources allocated to Project Y
var z_lb..z_ub: z;                         % Integer resources allocated to Project Z

var 0..(cost_x*x_ub + cost_y*y_ub + cost_z*z_ub): total_cost;  % Total cost in dollars


% Constraints
% Total capacity constraint: overall allocated resources cannot exceed capacity
constraint x + y + z <= total_capacity;

% Viability constraints: minimum resource requirements across projects
constraint 2 * x + y >= min_2x_plus_y;
constraint x + z >= min_x_plus_z;

% Total cost definition: compute total_cost from allocations and unit costs
constraint total_cost = cost_x * x + cost_y * y + cost_z * z;


% Objective
solve minimize total_cost;