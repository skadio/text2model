% Parameters
% Budget / capacity constraint coefficients and RHS
int: util_coeff_x = 5;          % utilization per unit allocated to department X
int: util_coeff_y = 3;          % utilization per unit allocated to department Y
int: util_max     = 100;        % maximum allowed combined utilization

% Service level constraint coefficients and RHS
int: service_coeff_x = 2;       % service contribution per unit allocated to X
int: service_coeff_y = 1;       % service contribution per unit allocated to Y
int: service_min     = 30;      % minimum required service level

% Balance constraint bound
int: balance_max_diff = 10;     % |x - y| must be <= this value

% Cost parameters
int: cost_x = 10;               % cost per unit allocated to X
int: cost_y = 20;               % cost per unit allocated to Y

% Derived upper bounds for decision variables (safe integer bounds)
int: x_ub = util_max div util_coeff_x;  % from 5*x <= 100 => x <= 20
int: y_ub = util_max div util_coeff_y;  % from 3*y <= 100 => y <= 33

% Variables
var 0..x_ub: x;                 % integer resource allocation to department X
var 0..y_ub: y;                 % integer resource allocation to department Y

% Total cost (bounded by max possible cost at variable upper bounds)
var 0..(cost_x * x_ub + cost_y * y_ub): total_cost;

% Constraints
% Budget / combined utilization capacity
constraint util_coeff_x * x + util_coeff_y * y <= util_max;

% Service level minimum requirement
constraint service_coeff_x * x + service_coeff_y * y >= service_min;

% Balance between departments (bounded absolute difference)
constraint abs(x - y) <= balance_max_diff;

% Total cost definition (linking cost variable to decisions)
constraint total_cost = cost_x * x + cost_y * y;

% Objective
solve minimize total_cost;