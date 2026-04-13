% Parameters
int: ferry_capacity = 20;          % Boxes per ferry trip
int: rail_capacity  = 15;          % Boxes per light rail trip
int: min_boxes      = 500;         % Minimum boxes to send
int: rail_to_ferry_ratio = 4;      % Light rail trips must be at least 4 times ferry trips

% Upper bounds for decision variables (safe, derived from minimum requirement)
int: max_ferry_trips = (min_boxes div ferry_capacity) + 1; % ceil-ish safe bound
int: max_rail_trips  = (min_boxes div rail_capacity) + 1;  % ceil-ish safe bound

% Variables
var 0..max_ferry_trips: ferry_trips; % Number of ferry trips
var 0..max_rail_trips: rail_trips;   % Number of light rail trips
var 0..(max_ferry_trips + max_rail_trips): total_trips; % Total trips (objective helper)

% Constraints

% Total boxes shipped must meet or exceed the minimum requirement
constraint
  ferry_capacity * ferry_trips + rail_capacity * rail_trips >= min_boxes;

% Light rail trips must be at least a given ratio times ferry trips
constraint
  rail_trips >= rail_to_ferry_ratio * ferry_trips;

% Define total trips as the sum of ferry and rail trips
constraint
  total_trips = ferry_trips + rail_trips;

% Objective
solve minimize total_trips;