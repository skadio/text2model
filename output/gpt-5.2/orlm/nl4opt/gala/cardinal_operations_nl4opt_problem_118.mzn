% Fish transport planning: minimize total time
include "globals.mzn";

% Data (embedded)
int: fish_needed = 300;
int: heli_capacity = 30;
int: car_capacity  = 20;
int: heli_time = 40;   % minutes per helicopter trip
int: car_time  = 30;   % minutes per car trip
int: max_heli_trips = 5;
int: car_share_num = 60;  % at least 60% of trips are by car
int: car_share_den = 100;

% Decision variables
var 0..max_heli_trips: heli_trips;
var 0..1000: car_trips;  % safe upper bound

% Constraints
constraint heli_capacity * heli_trips + car_capacity * car_trips >= fish_needed;

% At least 60% of trips by car:
% car_trips / (car_trips + heli_trips) >= 0.60
% => 100*car_trips >= 60*(car_trips + heli_trips)
constraint car_share_den * car_trips >= car_share_num * (car_trips + heli_trips);

% Objective: minimize total time
var int: total_time = heli_time * heli_trips + car_time * car_trips;

solve minimize total_time;

output [
  "helicopter_trips = ", show(heli_trips), "\n",
  "car_trips        = ", show(car_trips), "\n",
  "total_trips      = ", show(heli_trips + car_trips), "\n",
  "fish_moved       = ", show(heli_capacity*heli_trips + car_capacity*car_trips), "\n",
  "total_time_min   = ", show(total_time), "\n"
];