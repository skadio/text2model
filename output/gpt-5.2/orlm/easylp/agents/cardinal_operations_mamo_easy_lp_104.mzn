% Parameters
int: min_total_employees = 20;          % Minimum total employees across both projects
int: max_resource_capacity = 40;        % Maximum allowed for 2*X + Y
int: cost_per_employee_x = 50;          % Daily cost per employee assigned to Project X
int: cost_per_employee_y = 80;          % Daily cost per employee assigned to Project Y

% Variables
var 0..max_resource_capacity: employees_x;   % Integer employees assigned to Project X
var 0..max_resource_capacity: employees_y;   % Integer employees assigned to Project Y
var 0..(cost_per_employee_x*max_resource_capacity + cost_per_employee_y*max_resource_capacity): total_daily_cost;
                                            % Total daily staffing cost (bounded safely)

% Constraints
% Minimum manpower requirement: total employees across both projects must be at least the minimum
constraint
  employees_x + employees_y >= min_total_employees;

% Resource capacity limitation: twice employees in X plus employees in Y cannot exceed capacity
constraint
  2 * employees_x + employees_y <= max_resource_capacity;

% Define total daily cost from staffing levels and per-employee costs
constraint
  total_daily_cost = cost_per_employee_x * employees_x
                   + cost_per_employee_y * employees_y;

% Objective
solve minimize total_daily_cost;