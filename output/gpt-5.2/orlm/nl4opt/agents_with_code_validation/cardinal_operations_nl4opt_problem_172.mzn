% Parameters
% Hours and pay per shift for each teacher type
int: staff_hours_per_shift = 6;
int: staff_pay_per_shift   = 300;

int: sub_hours_per_shift   = 3;
int: sub_pay_per_shift     = 100;

% Requirements
int: required_total_hours = 1000;
int: total_budget         = 40000;

% Upper bounds (safe, derived from requirements/budget)
int: max_staff = min(required_total_hours div staff_hours_per_shift,
                     total_budget div staff_pay_per_shift);
int: max_sub   = min(required_total_hours div sub_hours_per_shift,
                     total_budget div sub_pay_per_shift);

% Variables
var 0..max_staff: num_staff; % number of staff teachers hired
var 0..max_sub:   num_sub;   % number of substitute teachers hired

% Constraints

% --- Teaching-hours coverage ---
% Ensure the hired teachers provide at least the required total teaching hours
constraint
  staff_hours_per_shift * num_staff + sub_hours_per_shift * num_sub
  >= required_total_hours;

% --- Budget feasibility ---
% Ensure total wage cost does not exceed the available budget
constraint
  staff_pay_per_shift * num_staff + sub_pay_per_shift * num_sub
  <= total_budget;

% Objective
solve minimize (num_staff + num_sub);