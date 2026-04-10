% Parameters (with values embedded)
int: demand = 1000;
int: pollution_limit = 1000;

set of int: T = 1..3; % 1=horse, 2=bicycle, 3=handcart

array[T] of int: capacity = [55, 30, 40];
array[T] of int: pollution = [80, 0, 0];

int: min_horse_trips = 8;

% Variables
int: max_horse_trips = pollution_limit div pollution[1]; % bound from pollution limit
var 0..max_horse_trips: trips_horse;
var 0..1000: trips_bicycle;  % safe upper bound
var 0..1000: trips_handcart; % safe upper bound

var bool: use_bicycle;
var bool: use_handcart;

% Constraints
constraint trips_horse >= min_horse_trips;

% Choose only one of bicycle or handcart (exactly one)
constraint use_bicycle + use_handcart = 1;

% Link selection to trip variables
constraint trips_bicycle <= 1000 * bool2int(use_bicycle);
constraint trips_handcart <= 1000 * bool2int(use_handcart);

% Pollution limit
constraint pollution[1] * trips_horse
         + pollution[2] * trips_bicycle
         + pollution[3] * trips_handcart
         <= pollution_limit;

% Transport at least the required produce
constraint capacity[1] * trips_horse
         + capacity[2] * trips_bicycle
         + capacity[3] * trips_handcart
         >= demand;

% Objective
solve minimize (pollution[1] * trips_horse
              + pollution[2] * trips_bicycle
              + pollution[3] * trips_handcart);