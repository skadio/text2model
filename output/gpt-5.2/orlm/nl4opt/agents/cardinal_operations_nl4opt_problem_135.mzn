% Parameters
int: seasonal_hours = 6;          % Hours worked per shift by a seasonal snow remover
int: permanent_hours = 10;        % Hours worked per shift by a permanent snow remover
int: seasonal_cost = 120;         % Cost per seasonal snow remover per shift ($)
int: permanent_cost = 250;        % Cost per permanent snow remover per shift ($)
int: required_hours = 300;        % Total labor hours required
int: budget = 6500;               % Total budget available ($)

% Helpful bounds for decision variables (derived from requirements/budget)
int: max_seasonal =
  max( (required_hours + seasonal_hours - 1) div seasonal_hours,
       budget div seasonal_cost );
int: max_permanent =
  max( (required_hours + permanent_hours - 1) div permanent_hours,
       budget div permanent_cost );

% Variables
var 0..max_seasonal: num_seasonal;    % Number of seasonal snow removers to hire
var 0..max_permanent: num_permanent;  % Number of permanent snow removers to hire

% Constraints

% Labor-hours requirement: total provided hours must meet or exceed the required hours
constraint
  seasonal_hours * num_seasonal + permanent_hours * num_permanent >= required_hours;

% Budget constraint: total cost of hired workers must not exceed the available budget
constraint
  seasonal_cost * num_seasonal + permanent_cost * num_permanent <= budget;

% Objective
solve minimize (num_seasonal + num_permanent);