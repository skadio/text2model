% Parameters
int: workforce_limit = 1000;          % Total number of employees available
int: max_x = 500;                     % Max employees in department X
int: max_y = 400;                     % Max employees in department Y
int: max_z = 300;                     % Max employees in department Z

int: min_diff_xy = 200;               % X must have at least 200 more employees than Y
int: min_diff_yz = 100;               % Y must have at least 100 more employees than Z

int: cost_x = 50;                     % Monthly cost per employee in X
int: cost_y = 60;                     % Monthly cost per employee in Y
int: cost_z = 70;                     % Monthly cost per employee in Z

% Variables
var 0..max_x: employees_x;            % Employees allocated to department X
var 0..max_y: employees_y;            % Employees allocated to department Y
var 0..max_z: employees_z;            % Employees allocated to department Z

var 0..(workforce_limit * max(cost_x, max(cost_y, cost_z))): total_monthly_cost;
                                      % Total monthly cost (bounded)

% Constraints

% Workforce availability: total allocated employees cannot exceed the workforce limit
constraint employees_x + employees_y + employees_z <= workforce_limit;

% Department staffing difference requirements
% X must have at least min_diff_xy more employees than Y
constraint employees_x >= employees_y + min_diff_xy;

% Y must have at least min_diff_yz more employees than Z
constraint employees_y >= employees_z + min_diff_yz;

% Total monthly cost definition (links cost variable to staffing decisions)
constraint total_monthly_cost
        = cost_x * employees_x + cost_y * employees_y + cost_z * employees_z;

% Objective
solve minimize total_monthly_cost;