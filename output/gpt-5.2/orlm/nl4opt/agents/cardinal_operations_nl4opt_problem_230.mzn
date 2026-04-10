% Parameters
int: container_capacity = 30;          % units of oil per container
int: truck_capacity = 40;              % units of oil per truck
int: min_oil_to_send = 2000;           % minimum total units of oil to send
int: min_containers = 15;              % minimum number of containers required

% Variables
% Upper bounds are loose but finite to keep the search space bounded.
var min_containers..(min_oil_to_send div container_capacity + 1000): containers;  % number of containers used
var 0..(min_oil_to_send div truck_capacity + 1000): trucks;                       % number of trucks used

% Constraints
% Minimum oil shipment requirement (combined capacity of containers and trucks)
constraint
  container_capacity * containers + truck_capacity * trucks >= min_oil_to_send;

% Minimum number of containers requirement
constraint
  containers >= min_containers;

% Government restriction: trucks used must be at most half the number of containers used
% Integer-safe form (avoids fractional division): 2*trucks <= containers
constraint
  2 * trucks <= containers;

% Objective
solve minimize containers + trucks;