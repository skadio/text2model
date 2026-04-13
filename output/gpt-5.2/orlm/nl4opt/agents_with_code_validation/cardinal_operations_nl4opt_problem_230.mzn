% Parameters
int: container_capacity = 30;          % units of oil per container
int: truck_capacity = 40;              % units of oil per truck
int: min_oil_to_send = 2000;           % minimum total units of oil to send
int: min_containers = 15;              % minimum number of containers required

% Variables
% Upper bounds use ceil to ensure feasibility even when division is not exact
var min_containers..ceil(min_oil_to_send / container_capacity): containers; % number of containers used
var 0..ceil(min_oil_to_send / truck_capacity): trucks;                      % number of trucks used

% Constraints
% Ensure the total oil shipped meets or exceeds the required minimum
constraint
  container_capacity * containers + truck_capacity * trucks >= min_oil_to_send;

% Enforce government restriction: trucks used must be at most half the containers used
% (integer-safe form)
constraint
  2 * trucks <= containers;

% Enforce minimum number of containers to be used (also implied by variable lower bound)
constraint
  containers >= min_containers;

% Objective
solve minimize containers + trucks;