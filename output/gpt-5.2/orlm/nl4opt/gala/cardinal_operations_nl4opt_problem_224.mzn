include "globals.mzn";

% Data (embedded as requested)
int: sub_capacity = 100;
int: sub_gas      = 30;
int: boat_capacity = 80;
int: boat_gas      = 25;

int: max_sub_trips = 6;
int: min_mail      = 1000;

% Decision variables
var 0..max_sub_trips: sub_trips;
% Upper bound for boat trips: if all were boats, need ceil(1000/80)=13
var 0..13: boat_trips;

% Constraints
constraint sub_trips * sub_capacity + boat_trips * boat_capacity >= min_mail;

% At least 50% of trips must be by boat:
% boat_trips >= 0.5*(sub_trips + boat_trips)  <=>  boat_trips >= sub_trips
constraint boat_trips >= sub_trips;

% Objective: minimize total gas used
var int: total_gas = sub_trips * sub_gas + boat_trips * boat_gas;

solve minimize total_gas;

output [
  "sub_trips = ", show(sub_trips), "\n",
  "boat_trips = ", show(boat_trips), "\n",
  "total_mail = ", show(sub_trips * sub_capacity + boat_trips * boat_capacity), "\n",
  "total_gas = ", show(total_gas), "\n"
];