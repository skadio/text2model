% Parameters
int: cost_x = 50;              % Cost per unit of product X
int: cost_y = 10;              % Cost per unit of product Y

int: a1_x = 2;                 % Coefficient of X in resource constraint
int: a1_y = 1;                 % Coefficient of Y in resource constraint
int: resource_cap = 200;       % Upper bound on resource usage

int: a2_x = 4;                 % Coefficient of X in demand constraint
int: a2_y = 1;                 % Coefficient of Y in demand constraint
int: demand_min = 50;          % Minimum required demand expression value

% Variables
var 0..resource_cap: x;        % Units of product X (nonnegative integer)
var 0..resource_cap: y;        % Units of product Y (nonnegative integer)

% Constraints
% Resource limitation: 2*x + y must not exceed the available capacity
constraint
  a1_x * x + a1_y * y <= resource_cap;

% Market demand requirement: 4*x + y must meet or exceed the minimum demand level
constraint
  a2_x * x + a2_y * y >= demand_min;

% Objective
solve minimize cost_x * x + cost_y * y;