% Parameters
int: total_employees_limit = 1000;         % Total employees available (upper bound)
int: min_diff_XY = 200;                    % X must be at least 200 more than Y
int: min_diff_YZ = 100;                    % Y must be at least 100 more than Z

int: cost_X = 50;                          % Monthly cost per employee in X
int: cost_Y = 60;                          % Monthly cost per employee in Y
int: cost_Z = 70;                          % Monthly cost per employee in Z

int: max_X = 500;                          % Capacity limit for X
int: max_Y = 400;                          % Capacity limit for Y
int: max_Z = 300;                          % Capacity limit for Z

% Variables
var 0..max_X: employees_X;                 % Employees allocated to department X
var 0..max_Y: employees_Y;                 % Employees allocated to department Y
var 0..max_Z: employees_Z;                 % Employees allocated to department Z

% Total monthly cost (tight upper bound from max capacities and costs)
var 0..(cost_X*max_X + cost_Y*max_Y + cost_Z*max_Z): total_monthly_cost;

% Constraints
% Workforce availability: do not allocate more than the total workforce limit
constraint
  employees_X + employees_Y + employees_Z <= total_employees_limit;

% Department staffing difference requirements
constraint
  employees_X >= employees_Y + min_diff_XY;
constraint
  employees_Y >= employees_Z + min_diff_YZ;

% Monthly cost computation (link total_monthly_cost to staffing decisions)
constraint
  total_monthly_cost =
    cost_X * employees_X + cost_Y * employees_Y + cost_Z * employees_Z;

% Objective
solve minimize total_monthly_cost;