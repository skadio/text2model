% Parameters
int: max_total_employees = 24;        % Maximum total employees across all shifts
int: min_morning = 4;                % Minimum employees required in morning shift (X)
int: min_afternoon = 6;              % Minimum employees required in afternoon shift (Y)
int: min_night = 5;                  % Minimum employees required in night shift (Z)

int: cost_morning = 8;               % Cost per employee (per hour) in morning shift
int: cost_afternoon = 6;             % Cost per employee (per hour) in afternoon shift
int: cost_night = 5;                 % Cost per employee (per hour) in night shift

% Variables
var min_morning..max_total_employees: x_morning;     % Employees scheduled in morning shift
var min_afternoon..max_total_employees: y_afternoon; % Employees scheduled in afternoon shift
var min_night..max_total_employees: z_night;         % Employees scheduled in night shift

% Upper bound on total cost if all 24 employees were (hypothetically) assigned to each shift
var 0..(cost_morning*max_total_employees
      + cost_afternoon*max_total_employees
      + cost_night*max_total_employees): total_cost; % Total labor cost (per hour)

% Constraints
% Staffing level constraints (also implied by variable domains, kept for clarity)
constraint x_morning >= min_morning;
constraint y_afternoon >= min_afternoon;
constraint z_night >= min_night;

% Total headcount constraint: do not exceed maximum total employees across all shifts
constraint x_morning + y_afternoon + z_night <= max_total_employees;

% Cost definition constraint: compute total labor cost from per-shift staffing and costs
constraint total_cost =
    cost_morning * x_morning
  + cost_afternoon * y_afternoon
  + cost_night * z_night;

% Objective
solve minimize total_cost;