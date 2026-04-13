% Parameters
int: regular_hours_per_shift = 10;      % hours provided by one regular fire fighter
int: regular_cost = 300;               % cost of one regular fire fighter
int: emergency_hours_per_shift = 6;    % hours provided by one emergency fire fighter
int: emergency_cost = 100;             % cost of one emergency fire fighter
int: min_total_hours = 300;            % minimum required total hours
int: budget = 7000;                    % maximum available budget

% Variables
var 0..(budget div regular_cost): num_regular;      % number of regular fire fighters hired
var 0..(budget div emergency_cost): num_emergency;  % number of emergency fire fighters hired

% Constraints

% Total hours requirement: ensure enough firefighter hours are staffed
constraint
  regular_hours_per_shift * num_regular
+ emergency_hours_per_shift * num_emergency
>= min_total_hours;

% Budget limit: total hiring cost must not exceed the available budget
constraint
  regular_cost * num_regular
+ emergency_cost * num_emergency
<= budget;

% Objective
solve minimize num_regular + num_emergency;