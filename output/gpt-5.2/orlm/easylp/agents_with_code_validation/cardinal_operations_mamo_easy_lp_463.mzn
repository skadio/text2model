% Parameters
int: total_allocation_max = 5000;     % Total resources allocated to X and Y cannot exceed this
int: x_allocation_min = 1000;         % Minimum resources required for warehouse X
int: y_allocation_max = 3000;         % Maximum capacity for warehouse Y
int: cost_per_unit_x = 50;            % Cost per unit allocated to X (dollars)
int: cost_per_unit_y = 75;            % Cost per unit allocated to Y (dollars)

% Variables
var x_allocation_min..total_allocation_max: x_alloc;   % Units allocated to warehouse X (integer)
var 0..y_allocation_max: y_alloc;                      % Units allocated to warehouse Y (integer)
var 0..(cost_per_unit_x * total_allocation_max + cost_per_unit_y * y_allocation_max): total_cost;

% Constraints
%--- Allocation feasibility constraints ---
constraint x_alloc + y_alloc <= total_allocation_max;  % Overall allocation limit
constraint x_alloc >= x_allocation_min;                % Min for X (also enforced by domain)
constraint y_alloc <= y_allocation_max;                % Max for Y (also enforced by domain)

%--- Cost calculation constraint ---
constraint total_cost = cost_per_unit_x * x_alloc + cost_per_unit_y * y_alloc;

% Objective
solve minimize total_cost;

output [
  "x_alloc = ", show(x_alloc), "\n",
  "y_alloc = ", show(y_alloc), "\n",
  "total_cost = $", show(total_cost), "\n"
];