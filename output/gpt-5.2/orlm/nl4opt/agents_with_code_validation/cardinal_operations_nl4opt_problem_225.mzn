% Parameters (embedded data)
int: monkeys = 300;                 % Total monkeys to transport
int: bus_capacity = 20;             % Monkeys per bus trip
int: car_capacity = 6;              % Monkeys per car trip
int: bus_time = 30;                 % Minutes per bus trip
int: car_time = 15;                 % Minutes per car trip
int: max_bus_trips = 10;            % Maximum bus trips
int: min_car_percent = 60;          % At least 60% of trips must be by car

% Variables
var 0..max_bus_trips: bus_trips;
var 0..monkeys: car_trips;          % Safe upper bound
var 0..(bus_time*max_bus_trips + car_time*monkeys): total_time;

% Constraints

% Enough capacity to transport all monkeys
constraint bus_capacity * bus_trips + car_capacity * car_trips >= monkeys;

% At least 60% of all trips are by car:
% car_trips / (bus_trips + car_trips) >= 0.6
% Use integer cross-multiplication: 100*car_trips >= 60*(bus_trips + car_trips)
constraint bus_trips + car_trips > 0;
constraint 100 * car_trips >= min_car_percent * (bus_trips + car_trips);

% Total time
constraint total_time = bus_time * bus_trips + car_time * car_trips;

% Objective
solve minimize total_time;

output [
  "bus_trips=", show(bus_trips), "\n",
  "car_trips=", show(car_trips), "\n",
  "total_time=", show(total_time), "\n"
];