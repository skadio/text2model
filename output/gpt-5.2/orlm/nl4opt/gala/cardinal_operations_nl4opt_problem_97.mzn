% Shipping company transportation planning (no external data required)

% Data (embedded from the problem statement)
int: truck_capacity = 50;     % packages per truck trip
int: car_capacity   = 30;     % packages per car trip
int: truck_gas      = 20;     % liters per truck trip
int: car_gas        = 15;     % liters per car trip
int: max_truck_trips = 5;
int: min_packages    = 500;

% Decision variables
var 0..max_truck_trips: truck_trips;
var 0..1000: car_trips;  % safe upper bound

% Derived
var 0..200000: total_packages = truck_capacity * truck_trips + car_capacity * car_trips;
var 0..200000: total_gas      = truck_gas * truck_trips + car_gas * car_trips;
var 0..200000: total_trips    = truck_trips + car_trips;

% Constraints
constraint total_packages >= min_packages;

% At least 30% of all trips must be by car:
% car_trips / total_trips >= 0.30  <=>  10*car_trips >= 3*total_trips
% Also implies total_trips > 0; enforce directly.
constraint total_trips >= 1;
constraint 10 * car_trips >= 3 * total_trips;

% Objective: minimize total gas
solve minimize total_gas;

output [
  "truck_trips = ", show(truck_trips), "\n",
  "car_trips   = ", show(car_trips), "\n",
  "total_trips = ", show(total_trips), "\n",
  "packages    = ", show(total_packages), "\n",
  "gas_liters  = ", show(total_gas), "\n"
];