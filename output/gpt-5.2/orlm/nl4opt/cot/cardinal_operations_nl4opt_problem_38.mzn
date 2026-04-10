% Parameters (with values embedded)
int: chickens_required = 1200;

int: bus_capacity = 100;
int: car_capacity = 40;

int: max_bus_trips = 10;
int: max_total_trips = ceil(chickens_required / min(bus_capacity, car_capacity)); % safe upper bound

int: bus_time_num = 2;   % 2 hours
int: bus_time_den = 1;

int: car_time_num = 3;   % 1.5 hours = 3/2
int: car_time_den = 2;

int: car_share_num = 60; % at least 60% trips by car
int: car_share_den = 100;

% Variables
var 0..max_bus_trips: bus_trips;
var 0..max_total_trips: car_trips;

% Constraints
constraint bus_trips <= max_bus_trips;

% Transport enough chickens
constraint bus_capacity * bus_trips + car_capacity * car_trips >= chickens_required;

% At least 60% of trips must be by car: car_trips >= 0.6*(bus_trips+car_trips)
% Multiply to avoid fractions: 100*car_trips >= 60*(bus_trips+car_trips) -> 40*car_trips >= 60*bus_trips
constraint 40 * car_trips >= 60 * bus_trips;

% Objective
% Minimize total time in half-hours to keep integer objective:
% bus: 2h = 4 half-hours; car: 1.5h = 3 half-hours
var int: total_time_half_hours = 4 * bus_trips + 3 * car_trips;

solve minimize total_time_half_hours;

output [
  "bus_trips = ", show(bus_trips), "\n",
  "car_trips = ", show(car_trips), "\n",
  "total_time_hours = ", show(total_time_half_hours), "/2\n"
];