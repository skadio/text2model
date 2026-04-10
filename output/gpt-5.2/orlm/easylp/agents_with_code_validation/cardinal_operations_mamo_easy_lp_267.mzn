% Parameters
int: total_employees = 20;          % Total available employees
int: cost_X = 5000;                 % Cost per employee on project X
int: cost_Y = 4000;                 % Cost per employee on project Y
int: cost_Z = 6000;                 % Cost per employee on project Z

int: min_X = 5;                     % Minimum employees required for project X
int: min_Y = 3;                     % Minimum employees required for project Y
int: min_Z = 2;                     % Minimum employees required for project Z


% Variables
var min_X..total_employees: employees_X;   % Employees assigned to project X
var min_Y..total_employees: employees_Y;   % Employees assigned to project Y
var min_Z..total_employees: employees_Z;   % Employees assigned to project Z

% Upper bound: worst-case all employees assigned to each project (loose but safe bound)
var 0..(cost_X*total_employees + cost_Y*total_employees + cost_Z*total_employees): total_cost;


% Constraints
% Staffing conservation: each employee is assigned to exactly one project
constraint employees_X + employees_Y + employees_Z = total_employees;

% Minimum staffing requirements (redundant with variable domains but kept for clarity)
constraint employees_X >= min_X;
constraint employees_Y >= min_Y;
constraint employees_Z >= min_Z;

% Total cost definition based on staffing levels and per-employee costs
constraint total_cost = cost_X * employees_X + cost_Y * employees_Y + cost_Z * employees_Z;


% Objective
solve minimize total_cost;