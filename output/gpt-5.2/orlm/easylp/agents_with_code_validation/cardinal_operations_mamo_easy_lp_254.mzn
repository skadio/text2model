% Parameters
int: total_budget_units = 1000;              % Maximum total units available across all warehouses
int: min_units_YZ = 800;                     % Minimum combined units required for warehouses Y and Z
int: max_diff_XZ = 200;                      % Maximum allowed absolute difference between X and Z allocations

int: cost_X = 2;                             % Cost per unit for warehouse X
int: cost_Y = 3;                             % Cost per unit for warehouse Y
int: cost_Z = 1;                             % Cost per unit for warehouse Z

% Variables
var 0..total_budget_units: units_X;          % Integer units allocated to warehouse X
var 0..total_budget_units: units_Y;          % Integer units allocated to warehouse Y
var 0..total_budget_units: units_Z;          % Integer units allocated to warehouse Z

var 0..(cost_X*total_budget_units + cost_Y*total_budget_units + cost_Z*total_budget_units): total_cost;
                                              % Total cost

% Constraints

% Total allocation must not exceed the overall available units (budget constraint)
constraint units_X + units_Y + units_Z <= total_budget_units;

% Minimum demand satisfaction: warehouses Y and Z combined must receive enough units
constraint units_Y + units_Z >= min_units_YZ;

% Balance constraint: absolute difference between allocations to X and Z is limited
constraint abs(units_X - units_Z) <= max_diff_XZ;

% Define total cost as the linear combination of per-warehouse costs and allocations
constraint total_cost = cost_X * units_X + cost_Y * units_Y + cost_Z * units_Z;

% Objective
solve minimize total_cost;