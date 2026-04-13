int: chickens = 1200;

int: bus_capacity = 100;
float: bus_time = 2.0;
int: max_bus_trips = 10;

int: car_capacity = 40;
float: car_time = 1.5;

int: percent = 100;
int: min_car_percent = 60;

var 0..max_bus_trips: bus_trips;
var 0..1000: car_trips; % safe upper bound

constraint bus_capacity * bus_trips + car_capacity * car_trips >= chickens;

% At least 60% of trips must be by car:
% car_trips / (bus_trips + car_trips) >= 0.60
constraint percent * car_trips >= min_car_percent * (bus_trips + car_trips);

var float: total_time = bus_time * int2float(bus_trips) + car_time * int2float(car_trips);

solve minimize total_time;

output [
  "bus_trips = ", show(bus_trips), "\n",
  "car_trips = ", show(car_trips), "\n",
  "total_time = ", show(total_time), "\n"
];