% Parameters
int: truck_capacity = 1000;        % patties per truck trip
int: van_capacity   = 500;         % patties per van trip
int: truck_cost     = 300;         % $ per truck trip
int: van_cost       = 100;         % $ per van trip
int: min_patties    = 50000;       % minimum patties to ship
int: budget         = 12500;       % maximum total cost ($)

% Variables
var 0..(budget div truck_cost): truck_trips;  % number of truck trips
var 0..(budget div van_cost):   van_trips;    % number of van trips

% Constraints
% Meet minimum shipment requirement (total patties shipped)
constraint
  truck_capacity * truck_trips + van_capacity * van_trips >= min_patties;

% Respect total budget constraint (total shipping cost)
constraint
  truck_cost * truck_trips + van_cost * van_trips <= budget;

% City maneuverability constraint: trucks must not exceed vans
constraint
  truck_trips <= van_trips;

% Objective
solve minimize truck_trips + van_trips;