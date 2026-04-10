% Parameters
int: total_employees = 20;          % Total employees available
int: cost_X = 5000;                % Cost per employee assigned to project X
int: cost_Y = 4000;                % Cost per employee assigned to project Y
int: cost_Z = 6000;                % Cost per employee assigned to project Z

int: min_X = 5;                    % Minimum employees required for project X
int: min_Y = 3;                    % Minimum employees required for project Y
int: min_Z = 2;                    % Minimum employees required for project Z

% Variables
var 0..total_employees: employees_X; % Number of employees assigned to project X
var 0..total_employees: employees_Y; % Number of employees assigned to project Y
var 0..total_employees: employees_Z; % Number of employees assigned to project Z

var int: total_cost;                % Total staffing cost across all projects

% Constraints
% Staffing balance: every employee must be assigned to exactly one project
constraint employees_X + employees_Y + employees_Z = total_employees;

% Minimum staffing requirements per project
constraint employees_X >= min_X;
constraint employees_Y >= min_Y;
constraint employees_Z >= min_Z;

% Total cost definition (link decision variables to cost variable)
constraint total_cost = cost_X * employees_X + cost_Y * employees_Y + cost_Z * employees_Z;

% Objective
solve minimize total_cost;