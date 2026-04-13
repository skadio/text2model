% Parameters (with values embedded)
int: boat_capacity = 10;
int: canoe_capacity = 8;
int: boat_time = 20;    % minutes per trip
int: canoe_time = 40;   % minutes per trip
int: max_boat_trips = 12;
int: min_ducks = 300;

% 60% of trips should be by canoe: canoe_trips >= 0.6*(boat_trips+canoe_trips)
% Equivalent integer form: 2*canoe_trips >= 3*boat_trips
% (since canoe >= 3/2 * boat)
% Variables
var 0..max_boat_trips: boat_trips;
var 0..200: canoe_trips; % safe upper bound (e.g., 200 canoes -> 1600 ducks)

% Constraints
constraint boat_trips <= max_boat_trips;

constraint 2 * canoe_trips >= 3 * boat_trips;

constraint boat_capacity * boat_trips + canoe_capacity * canoe_trips >= min_ducks;

% Objective
solve minimize boat_time * boat_trips + canoe_time * canoe_trips;