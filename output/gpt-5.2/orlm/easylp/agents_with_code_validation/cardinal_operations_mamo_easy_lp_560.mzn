% Parameters
int: total_budget = 5000;              % Maximum total allocation across X, Y, Z
int: min_alloc_X = 2000;               % Minimum allocation for initiative X
int: max_alloc_Y = 1000;               % Maximum allocation for initiative Y
int: min_alloc_Z = 500;                % Minimum allocation for initiative Z

int: cost_per_unit_X = 50;             % Cost per unit for X
int: cost_per_unit_Y = 100;            % Cost per unit for Y
int: cost_per_unit_Z = 150;            % Cost per unit for Z


% Variables
var 0..total_budget: alloc_X;          % Allocation to initiative X (whole units)
var 0..total_budget: alloc_Y;          % Allocation to initiative Y (whole units)
var 0..total_budget: alloc_Z;          % Allocation to initiative Z (whole units)

var 0..(cost_per_unit_X*total_budget
      + cost_per_unit_Y*total_budget
      + cost_per_unit_Z*total_budget): total_cost;  % Total cost to minimize


% Constraints
% Budget feasibility: total allocation across initiatives must not exceed total budget
constraint
  alloc_X + alloc_Y + alloc_Z <= total_budget;

% Initiative-specific minimum/maximum allocation requirements
constraint alloc_X >= min_alloc_X;     % X requires at least the minimum campaign funding
constraint alloc_Y <= max_alloc_Y;     % Y is capped due to regulatory limitations
constraint alloc_Z >= min_alloc_Z;     % Z requires at least the minimum training funding

% Total cost definition (linear cost aggregation)
constraint
  total_cost = cost_per_unit_X * alloc_X
             + cost_per_unit_Y * alloc_Y
             + cost_per_unit_Z * alloc_Z;


% Objective
solve minimize total_cost;