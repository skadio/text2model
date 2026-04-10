% Parameters
int: truck_capacity = 1000;          % Patties per truck trip
int: van_capacity   = 500;           % Patties per van trip
int: truck_cost     = 300;           % Cost per truck trip ($)
int: van_cost       = 100;           % Cost per van trip ($)
int: min_patties    = 50000;         % Minimum patties to ship
int: budget         = 12500;         % Maximum total budget ($)

% Variables
var 0..ceil(min_patties / truck_capacity): truck_trips;   % Number of truck trips
var 0..ceil(min_patties / van_capacity):   van_trips;     % Number of van trips
var 0..(ceil(min_patties / truck_capacity) + ceil(min_patties / van_capacity)): total_trips; % Total trips

% Constraints

% Total shipped patties must meet or exceed the minimum requirement
constraint
  truck_capacity * truck_trips + van_capacity * van_trips >= min_patties;

% Total shipping cost must not exceed the available budget
constraint
  truck_cost * truck_trips + van_cost * van_trips <= budget;

% City maneuverability restriction: trucks cannot exceed vans
constraint
  truck_trips <= van_trips;

% Define total trips as the sum of truck and van trips
constraint
  total_trips = truck_trips + van_trips;

% Objective
solve minimize total_trips;