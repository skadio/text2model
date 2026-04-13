% Parameters
int: budget = 1000;                      % Maximum total funding across X, Y, Z
int: min_2x_plus_y = 400;                % Minimum required for 2*X + Y
int: min_y_plus_z = 500;                 % Minimum required for Y + Z

int: benefit_x = 5;                      % Benefit units per dollar in X (given, not used in objective)
int: benefit_y = 3;                      % Benefit units per dollar in Y (given, not used in objective)
int: benefit_z = 1;                      % Benefit units per dollar in Z (given, not used in objective)

int: x_lb = 0; int: x_ub = 600;          % Bounds for program X funding
int: y_lb = 0; int: y_ub = 400;          % Bounds for program Y funding
int: z_lb = 0; int: z_ub = 300;          % Bounds for program Z funding

% Variables
var x_lb..x_ub: X;                       % Funding allocated to program X (integer dollars)
var y_lb..y_ub: Y;                       % Funding allocated to program Y (integer dollars)
var z_lb..z_ub: Z;                       % Funding allocated to program Z (integer dollars)

var 0..budget: total_cost;               % Total funding (cost) to be minimized

% Constraints
% Link total_cost to the sum of program allocations (ensures consistency)
constraint total_cost = X + Y + Z;

% Budget limit: total funding across X, Y, Z cannot exceed the available budget
constraint total_cost <= budget;

% Educational objective 1: combined funding for twice program X and program Y must be at least the required minimum
constraint 2 * X + Y >= min_2x_plus_y;

% Educational objective 2: combined funding for program Y and program Z must be at least the required minimum
constraint Y + Z >= min_y_plus_z;

% Objective
solve minimize total_cost;