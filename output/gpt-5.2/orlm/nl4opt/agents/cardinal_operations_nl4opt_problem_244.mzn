% Parameters
int: plane_capacity = 10;          % tires per plane trip
int: truck_capacity = 6;           % tires per truck trip
int: plane_cost = 1000;            % $ per plane trip
int: truck_cost = 700;             % $ per truck trip
int: min_tires = 200;              % minimum tires to transport
int: budget = 22000;               % total budget available ($)

% Variables
var 0..ceil(min_tires / plane_capacity): plane_trips;  % number of cargo plane trips
var 0..ceil(min_tires / truck_capacity): truck_trips;  % number of ultrawide truck trips
var 0..(ceil(min_tires / plane_capacity) + ceil(min_tires / truck_capacity)): total_trips; % total trips (objective helper)

% Constraints
% Link helper variable to decision variables (total trips)
constraint
  total_trips = plane_trips + truck_trips;

% Demand satisfaction: transport at least the required number of tires
constraint
  plane_capacity * plane_trips + truck_capacity * truck_trips >= min_tires;

% Budget constraint: total cost must not exceed available budget
constraint
  plane_cost * plane_trips + truck_cost * truck_trips <= budget;

% Feasibility constraint: plane trips cannot exceed truck trips
constraint
  plane_trips <= truck_trips;

% Objective
solve minimize total_trips;