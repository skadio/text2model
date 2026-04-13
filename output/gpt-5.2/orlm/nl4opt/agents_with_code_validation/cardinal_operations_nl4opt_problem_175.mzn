% Parameters
int: van_capacity = 50;              % boxes per van trip
int: truck_capacity = 80;            % boxes per truck trip
int: van_cost = 30;                  % dollars per van trip
int: truck_cost = 50;                % dollars per truck trip
int: min_boxes = 1500;               % minimum boxes to transport
int: budget = 1000;                  % maximum total cost allowed

% Variables
var 0..ceil(int2float(budget) / int2float(van_cost)): van_trips;        % number of van trips
var 0..ceil(int2float(budget) / int2float(truck_cost)): truck_trips;    % number of truck trips
var 0..(ceil(int2float(budget) / int2float(van_cost)) +
        ceil(int2float(budget) / int2float(truck_cost))): total_trips;  % total trips

% Constraints
% Total trips definition
constraint
  total_trips = van_trips + truck_trips;

% Minimum transport requirement (at least min_boxes boxes moved)
constraint
  van_capacity * van_trips + truck_capacity * truck_trips >= min_boxes;

% Budget constraint (total cost within budget)
constraint
  van_cost * van_trips + truck_cost * truck_trips <= budget;

% Advertising requirement: more van trips than truck trips
constraint
  van_trips > truck_trips;

% Objective
solve minimize total_trips;