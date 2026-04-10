% Parameters
% Work hours provided per worker type per shift
int: hours_seasonal = 6;
int: hours_permanent = 10;

% Cost per worker type per shift
int: cost_seasonal = 120;
int: cost_permanent = 250;

% Requirements
int: required_hours = 300;   % minimum total labor hours needed
int: budget = 6500;          % maximum total budget available

% Derived safe upper bounds for decision variables (integer bounds required)
int: max_seasonal = required_hours div hours_seasonal + 1;    % enough to cover hours alone
int: max_permanent = required_hours div hours_permanent + 1;  % enough to cover hours alone

% Variables
var 0..max_seasonal: num_seasonal;    % number of seasonal snow removers to hire
var 0..max_permanent: num_permanent;  % number of permanent snow removers to hire

% Constraints
% Labor-hours coverage: ensure hired workers provide at least the required hours
constraint
  hours_seasonal * num_seasonal + hours_permanent * num_permanent >= required_hours;

% Budget limit: total wages must not exceed the available budget
constraint
  cost_seasonal * num_seasonal + cost_permanent * num_permanent <= budget;

% Objective
solve minimize (num_seasonal + num_permanent);