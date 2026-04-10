% Parameters
int: total_budget = 500;                 % Maximum total investment units available

int: min_residential = 100;              % Minimum units for residential (X)
int: min_commercial  = 50;               % Minimum units for commercial (Y)
int: min_industrial  = 30;               % Minimum units for industrial (Z)

int: max_residential = 300;              % Maximum units for residential (X)
int: max_commercial  = 200;              % Maximum units for commercial (Y)
int: max_industrial  = 150;              % Maximum units for industrial (Z)

int: cost_residential = 100;             % Cost per unit for residential (X) in dollars
int: cost_commercial  = 200;             % Cost per unit for commercial (Y) in dollars
int: cost_industrial  = 150;             % Cost per unit for industrial (Z) in dollars


% Variables
var min_residential..max_residential: X; % Units invested in residential
var min_commercial..max_commercial:   Y; % Units invested in commercial
var min_industrial..max_industrial:   Z; % Units invested in industrial

% Upper bound: spend all budget at the maximum per-unit cost
int: max_unit_cost = max([cost_residential, cost_commercial, cost_industrial]);
var 0..(total_budget * max_unit_cost): total_cost;  % Total cost in dollars (objective)


% Constraints
% Budget feasibility: total invested units cannot exceed the available budget
constraint
  X + Y + Z <= total_budget;

% Total cost computation from per-unit costs and chosen investment units
constraint
  total_cost = cost_residential * X
             + cost_commercial  * Y
             + cost_industrial  * Z;


% Objective
solve minimize total_cost;

output [
  "X(residential)=", show(X), "\n",
  "Y(commercial)=",  show(Y), "\n",
  "Z(industrial)=",  show(Z), "\n",
  "minimum_total_cost=$", show(total_cost), "\n"
];