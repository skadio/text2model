% Parameters
int: monkeys = 300;
int: bus_cap = 20;
int: car_cap = 6;
int: bus_time = 30;   % minutes per bus trip
int: car_time = 15;   % minutes per car trip
int: max_bus_trips = 10;
int: car_pct = 60;    % at least 60% of trips should be by car

% Variables
var 0..max_bus_trips: bus_trips;
var 0..ceil(monkeys / car_cap): car_trips;

% Constraints
constraint bus_cap * bus_trips + car_cap * car_trips >= monkeys;

constraint bus_trips <= max_bus_trips;

% At least car_pct% of all trips are car:
% car_trips / (car_trips + bus_trips) >= car_pct/100
% => 100*car_trips >= car_pct*(car_trips + bus_trips)
constraint 100 * car_trips >= car_pct * (car_trips + bus_trips);

% Objective
solve minimize bus_time * bus_trips + car_time * car_trips;