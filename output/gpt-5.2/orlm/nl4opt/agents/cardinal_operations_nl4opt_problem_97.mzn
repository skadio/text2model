% Parameters
int: truck_capacity  = 50;   % packages per truck trip
int: car_capacity    = 30;   % packages per car trip
int: truck_gas       = 20;   % liters per truck trip
int: car_gas         = 15;   % liters per car trip
int: max_truck_trips = 5;    % maximum number of truck trips
int: min_packages    = 500;  % minimum packages to transport

% Variables
var 0..max_truck_trips: truck_trips;  % number of truck trips
var 0..17: car_trips;                 % number of car trips (safe upper bound)
var 0..355: total_gas;                % total liters of gas consumed (safe upper bound)

% Constraints
% Package demand: ensure total carried packages meets or exceeds requirement
constraint
  truck_capacity * truck_trips + car_capacity * car_trips >= min_packages;

% Truck trip limit (already enforced by variable domain, repeated for clarity)
constraint
  truck_trips <= max_truck_trips;

% Minimum fraction of trips by car: car_trips >= 30% of (car_trips + truck_trips)
% Implemented without floats: 7*car_trips >= 3*truck_trips
constraint
  7 * car_trips >= 3 * truck_trips;

% Upper bound on car trips (as derived and fixed in the given variables section)
constraint
  car_trips <= 17;

% Total gas consumed: linear linking of decision variables to total_gas
constraint
  total_gas = truck_gas * truck_trips + car_gas * car_trips;

% Objective
solve minimize total_gas;