% Parameters
int: tires_per_plane_trip = 10;          % Tires carried per cargo plane trip
int: tires_per_truck_trip = 6;           % Tires carried per ultrawide truck trip
int: cost_per_plane_trip = 1000;         % Cost per cargo plane trip ($)
int: cost_per_truck_trip = 700;          % Cost per ultrawide truck trip ($)
int: min_tires_required = 200;           % Minimum number of tires to transport
int: max_budget = 22000;                 % Maximum available budget ($)

% Variables
var 0..(max_budget div cost_per_plane_trip): plane_trips;   % Number of cargo plane trips
var 0..(max_budget div cost_per_truck_trip): truck_trips;   % Number of ultrawide truck trips
var 0..(max_budget div min(cost_per_plane_trip, cost_per_truck_trip)): total_trips; % Total trips (objective helper)

% Constraints
% Total tires delivered must meet or exceed the minimum requirement
constraint
  tires_per_plane_trip * plane_trips + tires_per_truck_trip * truck_trips
  >= min_tires_required;

% Total cost must not exceed the available budget
constraint
  cost_per_plane_trip * plane_trips + cost_per_truck_trip * truck_trips
  <= max_budget;

% Airport limitation: plane trips cannot exceed truck trips
constraint
  plane_trips <= truck_trips;

% Define total trips as the sum of plane and truck trips (objective helper)
constraint
  total_trips = plane_trips + truck_trips;

% Objective
solve minimize total_trips;