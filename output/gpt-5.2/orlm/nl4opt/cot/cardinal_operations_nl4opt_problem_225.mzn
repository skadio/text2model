% Parameters (with values embedded)
int: monkeys = 300;
int: bus_capacity = 20;
int: car_capacity = 6;
int: bus_time = 30;      % minutes per bus trip
int: car_time = 15;      % minutes per car trip
int: max_bus_trips = 10;
int: car_trip_percent_min = 60; % at least 60% of trips are by car

% Variables
var 0..max_bus_trips: bus_trips;
var 0..monkeys: car_trips;

% Constraints
constraint bus_trips * bus_capacity + car_trips * car_capacity >= monkeys;

% At least 60% of all trips are by car:
% car_trips / (bus_trips + car_trips) >= 0.60
% => 100*car_trips >= 60*(bus_trips + car_trips)
constraint 100 * car_trips >= car_trip_percent_min * (bus_trips + car_trips);

% Objective
var int: total_time = bus_trips * bus_time + car_trips * car_time;
solve minimize total_time;

output [
  "bus_trips=", show(bus_trips), "\n",
  "car_trips=", show(car_trips), "\n",
  "total_time=", show(total_time), " minutes\n",
  "monkeys_moved=", show(bus_trips * bus_capacity + car_trips * car_capacity), "\n"
];