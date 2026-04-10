% Parameters
int: cows_to_transport = 80;           % Total number of cows to move
int: heli_capacity = 3;               % Cows per helicopter trip
int: truck_capacity = 7;              % Cows per truck trip
int: heli_pollution = 5;              % Pollution units per helicopter trip
int: truck_pollution = 10;            % Pollution units per truck trip
int: max_truck_trips = 8;             % Maximum allowed truck trips

% Variables
var 0..cows_to_transport: heli_trips;  % Number of helicopter trips
var 0..max_truck_trips: truck_trips;   % Number of truck trips
var 0..(heli_pollution * cows_to_transport + truck_pollution * max_truck_trips): total_pollution;
                                       % Total pollution upper bound

% Constraints
% Transport requirement: move at least the required number of cows
constraint
  heli_capacity * heli_trips + truck_capacity * truck_trips >= cows_to_transport;

% Define total pollution based on chosen trips
constraint
  total_pollution = heli_pollution * heli_trips + truck_pollution * truck_trips;

% Objective
solve minimize total_pollution;