% Parameters
int: total_resource_limit = 1000;        % Maximum total resources available
int: min_2x_plus_y = 500;                % Minimum required value of 2*X + Y
int: max_x_plus_3z = 800;                % Maximum allowed value of X + 3*Z

int: cost_x = 10;                        % Cost per unit for project X
int: cost_y = 15;                        % Cost per unit for project Y
int: cost_z = 20;                        % Cost per unit for project Z

% Variables
var 0..total_resource_limit: x;          % Resource units allocated to project X
var 0..total_resource_limit: y;          % Resource units allocated to project Y
var 0..total_resource_limit: z;          % Resource units allocated to project Z

% Upper bound assumes any project could take the full budget (safe coarse bound)
var 0..(cost_x*total_resource_limit + cost_y*total_resource_limit + cost_z*total_resource_limit): total_cost;

% Constraints
% Resource budget constraint: total allocation cannot exceed available resources
constraint x + y + z <= total_resource_limit;

% Strategic requirement 1: ensure sufficient combined effort of X and Y
constraint 2 * x + y >= min_2x_plus_y;

% Strategic requirement 2: limit combined effort of X and Z
constraint x + 3 * z <= max_x_plus_3z;

% Total cost accounting: link decision variables to total_cost
constraint total_cost = cost_x * x + cost_y * y + cost_z * z;

% Objective
solve minimize total_cost;