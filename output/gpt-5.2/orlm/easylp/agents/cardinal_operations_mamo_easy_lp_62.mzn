% Parameters
% Resource cost coefficients
int: cost_per_unit_bandwidth = 5;      % resources per 1 unit bandwidth improvement
int: cost_per_unit_latency   = 10;     % resources per 1 unit latency reduction

% Constraint coefficients and bounds
int: a1_bandwidth = 2;                % coefficient of bandwidth in minimum service constraint
int: a1_latency   = 1;                % coefficient of latency in minimum service constraint
int: min_service  = 200;              % lower bound for service quality

int: a2_bandwidth = 3;                % coefficient of bandwidth in resource limitation constraint
int: a2_latency   = 1;                % coefficient of latency in resource limitation constraint
int: max_limit    = 500;              % upper bound for limitation

% Variables
var 0..500: bandwidth_improvement;     % integer units of bandwidth improvement (non-negative)
var 0..500: latency_reduction;         % integer units of latency reduction (non-negative)

% Total resource cost upper bound uses max possible values of decision variables
var 0..(cost_per_unit_bandwidth * 500 + cost_per_unit_latency * 500): total_resource_cost;

% Constraints
% Link total resource cost to decision variables (linear cost accounting)
constraint
  total_resource_cost
    = cost_per_unit_bandwidth * bandwidth_improvement
    + cost_per_unit_latency  * latency_reduction;

% Minimum service quality constraint: combined effect must be at least the required threshold
constraint
  a1_bandwidth * bandwidth_improvement
  + a1_latency * latency_reduction
  >= min_service;

% Resource limitation constraint: combined effect cannot exceed the maximum allowed limit
constraint
  a2_bandwidth * bandwidth_improvement
  + a2_latency * latency_reduction
  <= max_limit;

% Objective
solve minimize total_resource_cost;