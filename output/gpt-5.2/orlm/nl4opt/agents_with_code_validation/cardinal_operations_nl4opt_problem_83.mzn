% Parameters
int: runner_capacity = 3;          % bags per runner delivery
int: runner_time = 4;              % hours per runner delivery
int: canoe_capacity = 10;          % bags per canoe delivery
int: canoe_time = 2;               % hours per canoe delivery
int: total_hours_max = 200;        % maximum total hours available
int: min_runner_deliveries = 4;    % at least this many runner deliveries
int: canoe_share_max_pct = 33;     % at most 33% of deliveries by canoe

% Derived parameters for bounding
int: max_runner_deliveries = total_hours_max div runner_time;  % upper bound from hours
int: max_canoe_deliveries = total_hours_max div canoe_time;    % upper bound from hours


% Variables
var min_runner_deliveries..max_runner_deliveries: runner_deliveries; % number of runner deliveries
var 0..max_canoe_deliveries: canoe_deliveries;                       % number of canoe deliveries

var 0..(runner_capacity*max_runner_deliveries + canoe_capacity*max_canoe_deliveries): total_bags; % total bags delivered
var 0..total_hours_max: total_time;                                                             % total hours used
var 0..(max_runner_deliveries + max_canoe_deliveries): total_deliveries;                         % total number of deliveries


% Constraints
% Link total deliveries to decision variables
constraint total_deliveries = runner_deliveries + canoe_deliveries;

% Link total time usage to decision variables and enforce time limit
constraint total_time = runner_time * runner_deliveries + canoe_time * canoe_deliveries;
constraint total_time <= total_hours_max;

% Link total bags delivered to decision variables
constraint total_bags = runner_capacity * runner_deliveries + canoe_capacity * canoe_deliveries;

% At most 33% of deliveries can be by canoe (integer-safe linear form)
% canoe_deliveries / total_deliveries <= 33/100  <=> 100*c <= 33*(r+c)
% Note: total_deliveries >= min_runner_deliveries >= 4, so no divide-by-zero concerns.
constraint 100 * canoe_deliveries <= canoe_share_max_pct * total_deliveries;


% Objective
solve maximize total_bags;