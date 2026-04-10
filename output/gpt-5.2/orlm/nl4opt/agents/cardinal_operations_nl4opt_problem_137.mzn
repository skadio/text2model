% Parameters
int: cows_to_transport = 80;          % Total number of cows that must be transported
int: truck_trip_limit = 8;            % Maximum number of truck trips allowed

int: heli_capacity = 3;               % Cows transported per helicopter trip
int: truck_capacity = 7;              % Cows transported per truck trip

int: heli_pollution = 5;              % Pollution units per helicopter trip
int: truck_pollution = 10;            % Pollution units per truck trip

% Derived bounds for decision variables
int: max_heli_trips = ceil(cows_to_transport / heli_capacity);  % Enough helicopter trips to carry all cows alone

% Variables
var 0..max_heli_trips: heli_trips;    % Number of helicopter trips
var 0..truck_trip_limit: truck_trips; % Number of truck trips
var 0..(heli_pollution*max_heli_trips + truck_pollution*truck_trip_limit): total_pollution; % Total pollution

% Constraints

% Transportation requirement: carry at least the required number of cows
constraint
  heli_capacity * heli_trips + truck_capacity * truck_trips >= cows_to_transport;

% Truck availability limit: cannot exceed the allowed number of truck trips
constraint
  truck_trips <= truck_trip_limit;

% Define total pollution as the sum of pollution from each trip type
constraint
  total_pollution = heli_pollution * heli_trips + truck_pollution * truck_trips;

% Objective
solve minimize total_pollution;