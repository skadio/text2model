% Parameters
int: runner_capacity = 3;
int: runner_time = 4;
int: canoe_capacity = 10;
int: canoe_time = 2;

float: max_canoe_fraction = 0.33; % at most 33% of deliveries by canoe
int: max_total_hours = 200;
int: min_runners = 4;

% Upper bounds from hours (tight, safe integer bounds)
int: max_runners = max_total_hours div runner_time; % 50
int: max_canoes = max_total_hours div canoe_time;   % 100

% Variables
var min_runners..max_runners: runners;
var 0..max_canoes: canoes;

% Constraints
constraint runner_time * runners + canoe_time * canoes <= max_total_hours;

% At most 33% of deliveries by canoe:
% canoes / (canoes + runners) <= 0.33  <=>  67*canoes <= 33*(canoes + runners)
% <=> 34*canoes <= 33*runners
constraint 34 * canoes <= 33 * runners;

% Objective
solve maximize runner_capacity * runners + canoe_capacity * canoes;