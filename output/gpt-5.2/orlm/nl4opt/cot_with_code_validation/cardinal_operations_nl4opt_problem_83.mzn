% Parameters
int: runner_bags = 3;
int: runner_hours = 4;
int: canoe_bags  = 10;
int: canoe_hours = 2;

float: max_canoe_fraction = 0.33;
int: max_total_hours = 200;
int: min_runners = 4;

% Variables
var 0..(max_total_hours div runner_hours): runners;
var 0..(max_total_hours div canoe_hours): canoes;

var 0..(runner_bags * (max_total_hours div runner_hours) + canoe_bags * (max_total_hours div canoe_hours)): total_bags;

% Constraints
constraint runners >= min_runners;

constraint runner_hours * runners + canoe_hours * canoes <= max_total_hours;

% At most 33% of deliveries (trips) can be by canoe:
% canoes / (runners + canoes) <= 0.33  <=>  67*canoes <= 33*runners  (using 0.33 = 33/100)
constraint 67 * canoes <= 33 * runners;

constraint total_bags = runner_bags * runners + canoe_bags * canoes;

% Objective
solve maximize total_bags;