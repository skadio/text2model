% Parameters
int: budget = 5000;                 % Maximum total investment allowed
int: min_x_offset = 2000;           % Offset in X viability constraint
int: x_y_multiplier = -3;           % Multiplier on Y in X viability constraint
int: min_z_offset = 1000;           % Offset in Z viability constraint relative to Y

int: cost_x = 20;                   % Cost coefficient for X
int: cost_y = 15;                   % Cost coefficient for Y
int: cost_z = 30;                   % Cost coefficient for Z


% Variables
var 0..budget: X;                   % Investment in project X (non-negative integer)
var 0..budget: Y;                   % Investment in project Y (non-negative integer)
var 0..budget: Z;                   % Investment in project Z (non-negative integer)

% Total cost (bounded above by investing full budget in each, safe upper bound)
var 0..(cost_x*budget + cost_y*budget + cost_z*budget): total_cost;


% Constraints
% Budget constraint: total investment across projects cannot exceed the budget
constraint
  X + Y + Z <= budget;

% Viability constraint for project X: X >= min_x_offset + x_y_multiplier * Y
constraint
  X >= min_x_offset + x_y_multiplier * Y;

% Viability constraint for project Z: Z >= min_z_offset + Y
constraint
  Z >= min_z_offset + Y;

% Total cost definition: link total_cost to the linear cost expression
constraint
  total_cost = cost_x * X + cost_y * Y + cost_z * Z;


% Objective
solve minimize total_cost;

output [
  "X=", show(X), "\n",
  "Y=", show(Y), "\n",
  "Z=", show(Z), "\n",
  "total_cost=", show(total_cost), "\n"
];