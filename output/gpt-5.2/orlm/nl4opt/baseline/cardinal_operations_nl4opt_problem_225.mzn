int: monkeys = 300;

int: bus_capacity = 20;
int: car_capacity = 6;

int: bus_time = 30;   % minutes per bus trip
int: car_time = 15;   % minutes per car trip

int: max_bus_trips = 10;

% Decision variables: number of trips
var 0..max_bus_trips: bus_trips;
var 0..monkeys div car_capacity + 1000: car_trips; % safe upper bound

% Total trips and transported monkeys
var 0..max_bus_trips + (monkeys div car_capacity + 1000): total_trips =
    bus_trips + car_trips;

constraint bus_capacity * bus_trips + car_capacity * car_trips >= monkeys;

% At least 60% of the trips should be by car:
% car_trips / total_trips >= 0.6  <=>  5*car_trips >= 3*total_trips
constraint total_trips > 0;
constraint 5 * car_trips >= 3 * total_trips;

% Objective: minimize total time (minutes)
var 0..1000000: total_time = bus_time * bus_trips + car_time * car_trips;

solve minimize total_time;

output [
  "bus_trips = ", show(bus_trips), "\n",
  "car_trips = ", show(car_trips), "\n",
  "total_trips = ", show(total_trips), "\n",
  "total_time = ", show(total_time), " minutes\n",
  "transported = ", show(bus_capacity*bus_trips + car_capacity*car_trips), " monkeys\n"
];