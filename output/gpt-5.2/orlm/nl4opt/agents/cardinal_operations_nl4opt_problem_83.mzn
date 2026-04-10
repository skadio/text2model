% Parameters
int: runner_capacity = 3;              % bags per runner delivery
int: runner_time = 4;                  % hours per runner delivery
int: canoe_capacity = 10;              % bags per canoe delivery
int: canoe_time = 2;                   % hours per canoe delivery
int: total_hours_max = 200;            % maximum total hours available
int: min_runners = 4;                  % minimum number of runner deliveries
float: canoe_fraction_max = 0.33;      % at most 33% of deliveries by canoe

% Derived bounds (for bounded variable domains)
int: max_runner_deliveries = total_hours_max div runner_time;  % floor(200/4)=50
int: max_canoe_deliveries  = total_hours_max div canoe_time;   % floor(200/2)=100

% Variables
var min_runners..max_runner_deliveries: runner_deliveries;     % number of runner deliveries used
var 0..max_canoe_deliveries: canoe_deliveries;                 % number of canoe deliveries used
var 0..(runner_capacity*max_runner_deliveries + canoe_capacity*max_canoe_deliveries): total_bags; % total bags delivered

% Constraints

% Total time limit: runner and canoe deliveries must fit within available hours
constraint
  runner_time * runner_deliveries + canoe_time * canoe_deliveries
  <= total_hours_max;

% Total bags delivered: link total_bags to deliveries and their capacities
constraint
  total_bags
  = runner_capacity * runner_deliveries + canoe_capacity * canoe_deliveries;

% Minimum runner deliveries requirement (redundant with var domain but kept for clarity)
constraint
  runner_deliveries >= min_runners;

% At most 33% of deliveries can be by canoe.
% Avoid int/float coercion by cross-multiplying with integers:
% canoe_deliveries / (runner_deliveries + canoe_deliveries) <= 0.33
% => 100*canoe_deliveries <= 33*(runner_deliveries + canoe_deliveries)
constraint
  100 * canoe_deliveries <= 33 * (runner_deliveries + canoe_deliveries);

% Objective
solve maximize total_bags;