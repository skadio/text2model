% Parameters
int: total_capacity = 500;            % Maximum total capacity across all routes

% Minimum required allocations
int: min_x = 100;                     % Minimum capacity for route X
int: min_y = 150;                     % Minimum capacity for route Y
int: min_z = 200;                     % Minimum capacity for route Z

% Per-unit costs
int: cost_x = 5;                      % Cost per unit on route X
int: cost_y = 10;                     % Cost per unit on route Y
int: cost_z = 15;                     % Cost per unit on route Z

% Allocation bounds per route
int: lb_x = 0;  int: ub_x = 300;      % Lower/upper bound for X
int: lb_y = 0;  int: ub_y = 400;      % Lower/upper bound for Y
int: lb_z = 0;  int: ub_z = 600;      % Lower/upper bound for Z


% Variables
var lb_x..ub_x: x;                    % Capacity allocated to route X (integer)
var lb_y..ub_y: y;                    % Capacity allocated to route Y (integer)
var lb_z..ub_z: z;                    % Capacity allocated to route Z (integer)

var int: total_cost;                  % Total transportation cost (to minimize)


% Constraints
% Total capacity constraint (fleet size limit)
constraint x + y + z <= total_capacity;

% Minimum service level / demand constraints for each route
constraint x >= min_x;
constraint y >= min_y;
constraint z >= min_z;

% Total cost definition constraint
constraint total_cost = cost_x * x + cost_y * y + cost_z * z;


% Objective
solve minimize total_cost;