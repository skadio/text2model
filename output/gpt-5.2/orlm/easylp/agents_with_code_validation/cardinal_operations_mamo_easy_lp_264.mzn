% Parameters
int: max_total_staff = 200;          % Maximum total personnel supported by budget
int: min_staff_X = 50;              % Minimum required staffing for department X
int: min_staff_Y = 30;              % Minimum required staffing for department Y
int: min_staff_Z = 20;              % Minimum required staffing for department Z

int: cost_X = 5000;                 % Cost per employee in department X (USD)
int: cost_Y = 4000;                 % Cost per employee in department Y (USD)
int: cost_Z = 6000;                 % Cost per employee in department Z (USD)

% Variables
var min_staff_X..max_total_staff: staff_X;  % Employees in department X
var min_staff_Y..max_total_staff: staff_Y;  % Employees in department Y
var min_staff_Z..max_total_staff: staff_Z;  % Employees in department Z

var 0..(cost_X*max_total_staff + cost_Y*max_total_staff + cost_Z*max_total_staff): total_cost;
% Total cost (upper-bounded for safe linear modeling)

% Constraints
% Total headcount must not exceed the allowed maximum
constraint
  staff_X + staff_Y + staff_Z <= max_total_staff;

% Define total cost from staffing levels and per-employee costs
constraint
  total_cost = cost_X * staff_X + cost_Y * staff_Y + cost_Z * staff_Z;

% Objective
solve minimize total_cost;