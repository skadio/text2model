% Parameters (with values embedded)
int: runner_capacity = 3;
int: runner_time = 4;
int: canoe_capacity = 10;
int: canoe_time = 2;

float: max_canoe_fraction = 0.33;  % at most 33% of deliveries by canoe
int: max_total_hours = 200;
int: min_runners = 4;

% Variables
var min_runners..50: runners;  % upper bound from 4*runners <= 200 -> runners <= 50
var 0..100: canoes;            % upper bound from 2*canoes <= 200 -> canoes <= 100

% Constraints
constraint runner_time * runners + canoe_time * canoes <= max_total_hours;
constraint runners >= min_runners;

% At most 33% of deliveries by canoe:
% canoes / (runners + canoes) <= 0.33
% Use integer form: 100*canoes <= 33*(runners+canoes) -> 67*canoes <= 33*runners
constraint 67 * canoes <= 33 * runners;

% Objective
var int: total_mail = runner_capacity * runners + canoe_capacity * canoes;
solve maximize total_mail;