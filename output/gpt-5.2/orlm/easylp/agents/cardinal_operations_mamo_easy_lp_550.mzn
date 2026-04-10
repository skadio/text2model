% Parameters
int: total_employees = 100;              % Total employees available
int: min_x = 30;                         % Minimum employees for project X
int: min_y = 20;                         % Minimum employees for project Y
int: min_z = 10;                         % Minimum employees for project Z
int: cost_x = 5000;                      % Cost per employee for project X
int: cost_y = 7000;                      % Cost per employee for project Y
int: cost_z = 8000;                      % Cost per employee for project Z

% Variables
var min_x..total_employees: staff_x;     % Employees assigned to project X
var min_y..total_employees: staff_y;     % Employees assigned to project Y
var min_z..total_employees: staff_z;     % Employees assigned to project Z
var 0..(total_employees * max([cost_x, cost_y, cost_z])): total_cost; % Total cost (bounded)

% Constraints
% Allocate exactly all available employees across the three projects
constraint staff_x + staff_y + staff_z = total_employees;

% Define total cost from staffing levels and per-employee costs
constraint total_cost = cost_x * staff_x + cost_y * staff_y + cost_z * staff_z;

% Objective
solve minimize total_cost;