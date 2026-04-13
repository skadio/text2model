% Parameters
int: van_capacity = 50;          % boxes per van trip
int: truck_capacity = 80;        % boxes per truck trip
int: van_cost = 30;              % $ per van trip
int: truck_cost = 50;            % $ per truck trip
int: min_boxes = 1500;           % minimum boxes to transport
int: budget = 1000;              % maximum total cost ($)

% Upper bounds derived from budget (feasible over-approximations)
int: max_van_trips = budget div van_cost;
int: max_truck_trips = budget div truck_cost;

% Variables
var 0..max_van_trips: van_trips;       % number of van trips
var 0..max_truck_trips: truck_trips;   % number of truck trips

% Constraints

% Transport requirement: move at least the minimum number of boxes
constraint
  van_capacity * van_trips + truck_capacity * truck_trips >= min_boxes;

% Budget constraint: total transportation cost must not exceed the budget
constraint
  van_cost * van_trips + truck_cost * truck_trips <= budget;

% Advertising requirement: van trips must be strictly greater than truck trips
constraint
  van_trips > truck_trips;

% Objective
solve minimize van_trips + truck_trips;