% Parameters
int: total_budget = 5000;              % Maximum total budget across all sectors
int: min_x = 1500;                     % Minimum allocation for advertising (X)
int: min_y = 800;                      % Minimum allocation for transportation (Y)
int: min_z = 700;                      % Minimum allocation for hospitality (Z)

int: cost_x = 100;                     % Cost/return units per dollar in sector X
int: cost_y = 200;                     % Cost/return units per dollar in sector Y
int: cost_z = 50;                      % Cost/return units per dollar in sector Z

% Variables
var min_x..total_budget: invest_x;      % Dollars invested in advertising (X)
var min_y..total_budget: invest_y;      % Dollars invested in transportation (Y)
var min_z..total_budget: invest_z;      % Dollars invested in hospitality (Z)

var 0..(cost_x*total_budget + cost_y*total_budget + cost_z*total_budget): total_cost;
                                       % Total cost in units

% Constraints
%--- Budget feasibility: total allocation must not exceed the available budget
constraint
  invest_x + invest_y + invest_z <= total_budget;

%--- Total cost definition: compute total_cost from sector investments and per-dollar unit costs
constraint
  total_cost = cost_x * invest_x + cost_y * invest_y + cost_z * invest_z;

% Objective
solve minimize total_cost;