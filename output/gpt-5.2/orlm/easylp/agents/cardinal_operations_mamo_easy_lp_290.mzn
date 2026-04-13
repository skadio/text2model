% Parameters
int: min_total_resources = 50;          % Minimum total resources to allocate

int: coef_xy_x = 4;                    % Coefficient for X in constraint 4*X - Y <= 30
int: coef_xy_y = -1;                   % Coefficient for Y in constraint 4*X - Y <= 30
int: rhs_xy = 30;                      % RHS for constraint 4*X - Y <= 30

int: coef_zy_z = 1;                    % Coefficient for Z in constraint Z - 2*Y >= 10
int: coef_zy_y = -2;                   % Coefficient for Y in constraint Z - 2*Y >= 10
int: rhs_zy = 10;                      % RHS for constraint Z - 2*Y >= 10

int: cost_x = 5;                       % Cost per unit allocated to department X
int: cost_y = 3;                       % Cost per unit allocated to department Y
int: cost_z = 2;                       % Cost per unit allocated to department Z


% Variables
var 0..1000: x;                        % Integer resources allocated to department X
var 0..1000: y;                        % Integer resources allocated to department Y
var 0..1000: z;                        % Integer resources allocated to department Z

var 0..1000000: total_cost;            % Total cost to minimize (in dollars)


% Constraints
% Link total_cost to the allocation decisions and unit costs
constraint total_cost = cost_x * x + cost_y * y + cost_z * z;

% Ensure minimum total resources are allocated across all departments
constraint x + y + z >= min_total_resources;

% Enforce: 4*X - Y <= 30 (using provided coefficients/RHS)
constraint coef_xy_x * x + coef_xy_y * y <= rhs_xy;

% Enforce: Z - 2*Y >= 10 (using provided coefficients/RHS)
constraint coef_zy_z * z + coef_zy_y * y >= rhs_zy;


% Objective
solve minimize total_cost;