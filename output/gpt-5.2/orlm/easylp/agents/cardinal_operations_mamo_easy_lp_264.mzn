% Parameters
int: max_total_staff = 200;              % Total personnel capacity
int: min_staff_X = 50;                  % Minimum required staff in department X
int: min_staff_Y = 30;                  % Minimum required staff in department Y
int: min_staff_Z = 20;                  % Minimum required staff in department Z

int: cost_X = 5000;                     % Cost per employee in department X
int: cost_Y = 4000;                     % Cost per employee in department Y
int: cost_Z = 6000;                     % Cost per employee in department Z

% Variables
var min_staff_X..max_total_staff: staff_X;  % Number of employees allocated to X
var min_staff_Y..max_total_staff: staff_Y;  % Number of employees allocated to Y
var min_staff_Z..max_total_staff: staff_Z;  % Number of employees allocated to Z

% Total cost (upper bound uses max_total_staff for each dept as a safe bound)
var 0..(cost_X*max_total_staff + cost_Y*max_total_staff + cost_Z*max_total_staff): total_cost;

% Constraints
% Staffing capacity constraint: total allocated staff cannot exceed the maximum supported
constraint
  staff_X + staff_Y + staff_Z <= max_total_staff;

% Total cost calculation: sum of department staffing costs
constraint
  total_cost = cost_X * staff_X + cost_Y * staff_Y + cost_Z * staff_Z;

% Objective
solve minimize total_cost;