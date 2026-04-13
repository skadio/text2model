% Parameters
int: staff_hours_per_shift = 6;         % Hours provided by one staff teacher per shift
int: staff_cost_per_shift  = 300;       % Cost of one staff teacher per shift ($)

int: sub_hours_per_shift   = 3;         % Hours provided by one substitute teacher per shift
int: sub_cost_per_shift    = 100;       % Cost of one substitute teacher per shift ($)

int: required_total_hours  = 1000;      % Minimum required teaching hours
int: total_budget          = 40000;     % Maximum available budget ($)

% Upper bounds derived from budget (cannot hire more than budget allows)
int: max_staff = total_budget div staff_cost_per_shift;
int: max_subs  = total_budget div sub_cost_per_shift;

% Variables
var 0..max_staff: n_staff;              % Number of staff teachers hired
var 0..max_subs:  n_subs;               % Number of substitute teachers hired

% Constraints

% Teaching-hours coverage: total provided hours must meet or exceed the requirement
constraint
  staff_hours_per_shift * n_staff + sub_hours_per_shift * n_subs >= required_total_hours;

% Budget limit: total cost of hired teachers must not exceed available budget
constraint
  staff_cost_per_shift * n_staff + sub_cost_per_shift * n_subs <= total_budget;

% Objective
solve minimize (n_staff + n_subs);