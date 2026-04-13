% Parameters
int: budget = 1000;                         % Total investment budget upper bound
int: min_effectiveness = 800;               % Minimum required effectiveness
int: max_diff_XY = 300;                     % Maximum allowed absolute difference between X and Y

int: eff_X = 3;                             % Effectiveness coefficient for purchasing (X)
int: eff_Y = 2;                             % Effectiveness coefficient for manufacturing (Y)
int: eff_Z = 1;                             % Effectiveness coefficient for distribution (Z)

int: cost_X = 2;                            % Unit cost for purchasing (X)
int: cost_Y = 3;                            % Unit cost for manufacturing (Y)
int: cost_Z = 1;                            % Unit cost for distribution (Z)

% Variables
var 0..budget: X;                           % Investment in purchasing (integer, non-negative)
var 0..budget: Y;                           % Investment in manufacturing (integer, non-negative)
var 0..budget: Z;                           % Investment in distribution (integer, non-negative)

% Upper bound: worst-case when X=Y=Z=budget
var 0..(cost_X*budget + cost_Y*budget + cost_Z*budget): total_cost;  % Total cost to minimize

% Constraints
% Budget limit: total investment across purchasing, manufacturing, distribution
constraint
  X + Y + Z <= budget;

% Demand/effectiveness requirement: combined effectiveness must reach minimum
constraint
  eff_X * X + eff_Y * Y + eff_Z * Z >= min_effectiveness;

% Operational balance: absolute difference between purchasing and manufacturing bounded
constraint
  abs(X - Y) <= max_diff_XY;

% Total cost definition: link total_cost to component costs
constraint
  total_cost = cost_X * X + cost_Y * Y + cost_Z * Z;

% Objective
solve minimize total_cost;