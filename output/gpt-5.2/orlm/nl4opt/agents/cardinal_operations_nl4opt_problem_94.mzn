% Parameters
int: ferry_capacity = 20;          % boxes per ferry trip
int: rail_capacity  = 15;          % boxes per light rail trip
int: min_boxes      = 500;         % minimum boxes to ship
int: rail_to_ferry_ratio = 4;      % rail trips must be at least 4 times ferry trips

% Useful derived bounds (for variable bounding)
int: max_total_trips = min_boxes;                         % safe upper bound (1 box per trip worst-case)
int: max_ferry_trips = min_boxes div ferry_capacity + 1;  % safe upper bound
int: max_rail_trips  = min_boxes div rail_capacity + 1;   % safe upper bound

% Variables
var 0..max_ferry_trips: ferry_trips;   % number of ferry trips
var 0..max_rail_trips:  rail_trips;    % number of light rail trips
var 0..max_total_trips: total_trips;   % total number of trips (ferry + rail)

% Constraints
% Total trips definition
constraint total_trips = ferry_trips + rail_trips;

% Minimum shipment requirement (ensure at least min_boxes are shipped)
constraint ferry_capacity * ferry_trips + rail_capacity * rail_trips >= min_boxes;

% Mode ratio requirement (rail trips at least rail_to_ferry_ratio times ferry trips)
constraint rail_trips >= rail_to_ferry_ratio * ferry_trips;

% Objective
solve minimize total_trips;