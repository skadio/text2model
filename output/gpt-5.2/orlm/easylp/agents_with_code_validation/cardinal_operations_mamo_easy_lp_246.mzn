% Parameters
int: max_total_employees = 24;                 % Maximum employees allowed across all shifts

int: min_morning_employees = 4;               % Minimum employees required in morning shift (X)
int: min_afternoon_employees = 6;             % Minimum employees required in afternoon shift (Y)
int: min_night_employees = 5;                 % Minimum employees required in night shift (Z)

int: cost_morning_per_hour = 8;               % Cost per employee-hour in morning shift
int: cost_afternoon_per_hour = 6;             % Cost per employee-hour in afternoon shift
int: cost_night_per_hour = 5;                 % Cost per employee-hour in night shift

% Variables
var min_morning_employees..max_total_employees: X;   % Employees in morning shift
var min_afternoon_employees..max_total_employees: Y; % Employees in afternoon shift
var min_night_employees..max_total_employees: Z;     % Employees in night shift

% Upper bound: worst-case cost if all max_total_employees were paid at the max hourly rate
int: max_cost_per_hour = max(cost_morning_per_hour, max(cost_afternoon_per_hour, cost_night_per_hour));
var 0..(max_total_employees * max_cost_per_hour): total_cost; % Total labor cost (integer dollars)

% Constraints
% Staffing capacity constraint: total employees across shifts must not exceed the maximum
constraint
  X + Y + Z <= max_total_employees;

% Cost aggregation constraint: total labor cost computed from shift staffing levels and per-hour costs
constraint
  total_cost = cost_morning_per_hour * X
             + cost_afternoon_per_hour * Y
             + cost_night_per_hour * Z;

% Objective
solve minimize total_cost;