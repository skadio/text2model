% Parameters
int: budget = 5000;                 % Maximum total investment allowed
int: min_offset_X = 2000;           % X must be at least this much more than -3*Y
int: mult_Y_in_X = -3;              % Coefficient of Y in X viability constraint
int: min_offset_Z = 1000;           % Z must be at least this much more than Y

int: cost_X = 20;                   % Cost per unit investment in X
int: cost_Y = 15;                   % Cost per unit investment in Y
int: cost_Z = 30;                   % Cost per unit investment in Z

% Variables
var 0..budget: X;                   % Investment in project X (integer, non-negative)
var 0..budget: Y;                   % Investment in project Y (integer, non-negative)
var 0..budget: Z;                   % Investment in project Z (integer, non-negative)

% Upper bound: if all budget were spent in each (loose but safe bound)
var 0..(cost_X*budget + cost_Y*budget + cost_Z*budget): total_cost;

% Constraints
% Budget constraint: total investment across projects cannot exceed available budget
constraint
  X + Y + Z <= budget;

% Viability constraint for project X: X must be at least min_offset_X more than mult_Y_in_X * Y
constraint
  X >= min_offset_X + mult_Y_in_X * Y;   % X >= 2000 - 3*Y

% Viability constraint for project Z: Z must be at least min_offset_Z more than Y
constraint
  Z >= min_offset_Z + Y;                 % Z >= 1000 + Y

% Total cost definition: linear combination of investments and per-unit costs
constraint
  total_cost = cost_X * X + cost_Y * Y + cost_Z * Z;

% Objective
solve minimize total_cost;