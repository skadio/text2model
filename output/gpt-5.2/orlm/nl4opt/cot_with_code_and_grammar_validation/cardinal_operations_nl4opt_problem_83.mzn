% Parameters
int: runner_capacity = 3;          % bags per runner delivery
int: runner_time = 4;              % hours per runner delivery
int: canoe_capacity = 10;          % bags per canoe delivery
int: canoe_time = 2;               % hours per canoe delivery
int: max_total_hours = 200;
int: min_runners = 4;
int: canoe_max_percent = 33;       % percent of deliveries

% Variables
var 0..(max_total_hours div canoe_time): canoers;     % number of canoe deliveries
var min_runners..(max_total_hours div runner_time): runners; % number of runner deliveries
var 0..(runner_capacity*(max_total_hours div runner_time) + canoe_capacity*(max_total_hours div canoe_time)): total_bags;

% Constraints
constraint runner_time * runners + canoe_time * canoers <= max_total_hours;

% At most 33% of deliveries by canoe:
% canoers / (canoers + runners) <= 33/100  =>  100*canoers <= 33*(canoers + runners)
constraint 100 * canoers <= canoe_max_percent * (canoers + runners);

constraint total_bags = runner_capacity * runners + canoe_capacity * canoers;

% Objective
solve maximize total_bags;