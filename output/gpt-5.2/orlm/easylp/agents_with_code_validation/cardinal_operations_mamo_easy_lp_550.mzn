% Parameters
int: total_employees = 100;                 % Total employees available
int: min_x = 30;                            % Minimum employees for project X
int: min_y = 20;                            % Minimum employees for project Y
int: min_z = 10;                            % Minimum employees for project Z
int: cost_x = 5000;                         % Cost per employee for project X
int: cost_y = 7000;                         % Cost per employee for project Y
int: cost_z = 8000;                         % Cost per employee for project Z

% Variables
var min_x..total_employees: employees_x;    % Employees allocated to project X
var min_y..total_employees: employees_y;    % Employees allocated to project Y
var min_z..total_employees: employees_z;    % Employees allocated to project Z

% Upper bound uses the highest per-employee cost for all employees
var 0..(total_employees * max([cost_x, cost_y, cost_z])): total_cost; % Total cost (bounded)

% Constraints
%--- Minimum staffing requirements (already enforced by variable domains, stated explicitly for clarity)
constraint employees_x >= min_x;
constraint employees_y >= min_y;
constraint employees_z >= min_z;

%--- Total available employees must be fully allocated across projects
constraint employees_x + employees_y + employees_z = total_employees;

%--- Define total cost as the sum of per-project staffing costs
constraint total_cost =
    cost_x * employees_x +
    cost_y * employees_y +
    cost_z * employees_z;

% Objective
solve minimize total_cost;