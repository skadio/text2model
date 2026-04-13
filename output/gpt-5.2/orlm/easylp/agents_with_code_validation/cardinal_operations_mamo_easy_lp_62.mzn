% Parameters
% Resource cost per unit increase in bandwidth
int: cost_per_bandwidth_unit = 5;
% Resource cost per unit decrease in latency
int: cost_per_latency_unit = 10;

% Minimum service quality threshold
int: min_quality = 200;
% Maximum allowed combined-effect limit
int: max_limit = 500;

% Variables
% Integer units of bandwidth improvement (non-negative)
var 0..max_limit: bandwidth_improvement;
% Integer units of latency reduction (non-negative)
var 0..max_limit: latency_reduction;

% Total resource cost to minimize (bounded for linear expressions)
var 0..(cost_per_bandwidth_unit * max_limit + cost_per_latency_unit * max_limit): total_resource_cost;

% Constraints
% Link total resource cost to chosen improvements
constraint
  total_resource_cost =
    cost_per_bandwidth_unit * bandwidth_improvement +
    cost_per_latency_unit  * latency_reduction;

% Minimum service quality requirement
constraint
  2 * bandwidth_improvement + latency_reduction >= min_quality;

% Maximum limitation on combined effect
constraint
  3 * bandwidth_improvement + latency_reduction <= max_limit;

% Objective
solve minimize total_resource_cost;