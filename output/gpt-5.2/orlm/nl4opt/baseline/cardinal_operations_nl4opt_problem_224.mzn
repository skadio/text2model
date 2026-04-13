% Mail transport optimization: minimize gas while meeting mail requirement
% Data embedded as parameters

int: sub_capacity = 100;
int: boat_capacity = 80;

int: sub_gas = 30;
int: boat_gas = 25;

int: max_sub_trips = 6;
int: min_mail = 1000;

var 0..max_sub_trips: sub_trips;
var 0..100: boat_trips; % safe upper bound

constraint
  sub_capacity * sub_trips + boat_capacity * boat_trips >= min_mail;

% At least 50% of the trips must be by boat:
% boat_trips >= 0.5 * (sub_trips + boat_trips)  <=>  boat_trips >= sub_trips
constraint
  boat_trips >= sub_trips;

var int: total_gas = sub_gas * sub_trips + boat_gas * boat_trips;

solve minimize total_gas;

output [
  "sub_trips=", show(sub_trips), "\n",
  "boat_trips=", show(boat_trips), "\n",
  "total_mail=", show(sub_capacity * sub_trips + boat_capacity * boat_trips), "\n",
  "total_gas=", show(total_gas), "\n"
];