% Parameters
int: boat_capacity = 10;              % ducks per boat trip
int: canoe_capacity = 8;              % ducks per canoe trip
int: boat_time = 20;                  % minutes per boat trip
int: canoe_time = 40;                 % minutes per canoe trip
int: max_boat_trips = 12;             % at most 12 boat trips
int: min_ducks = 300;                 % at least 300 ducks must be transported

int: canoe_share_num = 60;            % at least 60% of trips are canoe
int: canoe_share_den = 100;

% Variables
var 0..max_boat_trips: boat_trips;    % number of boat trips (bounded by max)
var 0..1000: canoe_trips;             % number of canoe trips (safe upper bound)

var 0..100000: total_time;            % total minutes (explicit bound for linear expr)

% Constraints
% Capacity constraint: transport at least the required number of ducks
constraint
  boat_capacity * boat_trips + canoe_capacity * canoe_trips >= min_ducks;

% Boat trip limit: at most max_boat_trips boat trips (also ensured by variable domain)
constraint
  boat_trips <= max_boat_trips;

% Canoe share constraint: at least 60% of all trips are by canoe
% Cross-multiplied to avoid division and keep it linear:
% 100 * canoe_trips >= 60 * (boat_trips + canoe_trips)
constraint
  canoe_share_den * canoe_trips >= canoe_share_num * (boat_trips + canoe_trips);

% Define total time based on trips taken
constraint
  total_time = boat_time * boat_trips + canoe_time * canoe_trips;

% Ensure there is at least one trip (implied by min_ducks, but explicit for clarity)
constraint
  boat_trips + canoe_trips >= 1;

% Objective
solve minimize total_time;