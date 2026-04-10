include "globals.mzn";

% Data (embedded as required)
int: people_needed = 550;

int: kayak_capacity = 4;
int: boat_capacity  = 5;

int: kayak_time = 5;   % minutes per trip
int: boat_time  = 3;   % minutes per trip

int: max_boat_trips = 25;
int: kayak_ratio_num = 75;  % at least 75% of trips are kayaks
int: kayak_ratio_den = 100;

% Decision variables
var 0..200: kayak_trips;     % safe upper bound: 200*4 = 800 people
var 0..max_boat_trips: boat_trips;

% Total time (objective)
var int: total_time = kayak_time * kayak_trips + boat_time * boat_trips;

% Constraints
constraint kayak_capacity * kayak_trips + boat_capacity * boat_trips >= people_needed;

% At least 75% of all trips are by kayak:
% kayak_trips / (kayak_trips + boat_trips) >= 0.75
constraint kayak_ratio_den * kayak_trips >= kayak_ratio_num * (kayak_trips + boat_trips);

solve minimize total_time;

output [
  "kayak_trips = ", show(kayak_trips), "\n",
  "boat_trips  = ", show(boat_trips), "\n",
  "people_moved = ", show(kayak_capacity*kayak_trips + boat_capacity*boat_trips), "\n",
  "total_time_minutes = ", show(total_time), "\n"
];