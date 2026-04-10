% Parameters
% Minimum number of locals to transport
int: min_locals = 550;

% Capacity per trip
int: kayak_capacity = 4;
int: motorboat_capacity = 5;

% Time per trip (minutes)
int: kayak_time = 5;
int: motorboat_time = 3;

% Motorboat trip limit
int: max_motorboat_trips = 25;

% Minimum fraction of trips that must be by kayak (75% = 3/4)
int: min_kayak_frac_num = 3;
int: min_kayak_frac_den = 4;

% Upper bound on total trips (worst-case all trips are kayaks)
% ceil(550/4) = 138
int: max_total_trips = (min_locals + kayak_capacity - 1) div kayak_capacity;


% Variables
% Number of kayak trips
var 0..max_total_trips: kayak_trips;

% Number of motorboat trips
var 0..max_motorboat_trips: motorboat_trips;

% Total time in minutes
var 0..(kayak_time * max_total_trips + motorboat_time * max_motorboat_trips): total_time;


% Constraints
% Transport enough locals (capacity constraints)
constraint
  kayak_capacity * kayak_trips + motorboat_capacity * motorboat_trips >= min_locals;

% Motorboat availability limit
constraint
  motorboat_trips <= max_motorboat_trips;

% At least 75% of all trips are by kayak:
% kayak_trips / (kayak_trips + motorboat_trips) >= 3/4
% Cross-multiplied to avoid division:
constraint
  min_kayak_frac_den * kayak_trips >=
  min_kayak_frac_num * (kayak_trips + motorboat_trips);

% Define total time from trips and per-trip times
constraint
  total_time = kayak_time * kayak_trips + motorboat_time * motorboat_trips;


% Objective
solve minimize total_time;

output [
  "kayak_trips = ", show(kayak_trips), "\n",
  "motorboat_trips = ", show(motorboat_trips), "\n",
  "total_time = ", show(total_time), " minutes\n"
];