% Parameters
int: budget = 1000;                      % Maximum total investment allowed
int: min_strength = 400;                 % Minimum required strength
int: max_diff_zy = 300;                  % Maximum allowed difference between Z and Y (Z - Y <= 300)

int: strength_x_coeff = 3;               % Strength contribution coefficient for X
int: strength_y_coeff = 2;               % Strength contribution coefficient for Y

int: cost_x = 300;                       % Cost per unit of X
int: cost_y = 500;                       % Cost per unit of Y
int: cost_z = 200;                       % Cost per unit of Z

% Variables
var 0..budget: x;                        % Units allocated to project X
var 0..budget: y;                        % Units allocated to project Y
var 0..budget: z;                        % Units allocated to project Z

var 0..(cost_x*budget + cost_y*budget + cost_z*budget): total_cost; % Total cost (in dollars)

% Constraints
% Budget constraint: total investment across X, Y, Z cannot exceed the budget
constraint x + y + z <= budget;

% Minimum strength requirement: 3*X + 2*Y must be at least the required minimum
constraint strength_x_coeff * x + strength_y_coeff * y >= min_strength;

% Balance constraint between Z and Y: Z - Y must not exceed the specified maximum difference
constraint z - y <= max_diff_zy;

% Dominance constraint: allocation to X must be greater than twice allocation to Z
constraint x > 2 * z;

% Total cost definition (kept consistent with integer allocations)
constraint total_cost = cost_x * x + cost_y * y + cost_z * z;

% Objective
solve minimize total_cost;