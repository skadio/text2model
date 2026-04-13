% Parameters
int: ducks_per_boat_trip = 10;          % capacity of a boat per trip (ducks)
int: ducks_per_canoe_trip = 8;          % capacity of a canoe per trip (ducks)

int: minutes_per_boat_trip = 20;        % time per boat trip (minutes)
int: minutes_per_canoe_trip = 40;       % time per canoe trip (minutes)

int: max_boat_trips = 12;               % at most this many boat trips
int: min_ducks_total = 300;             % at least this many ducks transported

int: min_canoe_fraction_num = 60;       % 60% = 60/100 (use integer ratio)
int: min_canoe_fraction_den = 100;

% Variables
var 0..max_boat_trips: boat_trips;      % number of boat trips

% Upper bound: if all trips were canoe, need ceil(300/8)=38 trips; allow a safe bound.
var 0..38: canoe_trips;                 % number of canoe trips

var 0..1000: total_ducks;               % total ducks transported (bounded safely)
var 0..100000: total_time_minutes;      % total transport time (bounded safely)

% Constraints
% Link total_ducks to trips and per-trip capacities
constraint total_ducks =
  ducks_per_boat_trip * boat_trips + ducks_per_canoe_trip * canoe_trips;

% Ensure at least the required number of ducks are transported
constraint total_ducks >= min_ducks_total;

% Respect the maximum number of boat trips (also enforced by variable domain, kept for clarity)
constraint boat_trips <= max_boat_trips;

% At least 60% of all trips should be by canoe:
% canoe_trips / (boat_trips + canoe_trips) >= 60/100
% Cross-multiplied to avoid floats:
constraint
  min_canoe_fraction_den * canoe_trips >=
  min_canoe_fraction_num * (boat_trips + canoe_trips);

% Link total_time_minutes to trips and per-trip durations
constraint total_time_minutes =
  minutes_per_boat_trip * boat_trips + minutes_per_canoe_trip * canoe_trips;

% Objective
solve minimize total_time_minutes;