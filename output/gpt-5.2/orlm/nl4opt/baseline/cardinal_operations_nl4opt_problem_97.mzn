% Shipping company transportation optimization
% Decision variables: number of trips by truck and car

int: truck_capacity = 50;
int: car_capacity   = 30;

int: truck_gas = 20;
int: car_gas   = 15;

int: max_truck_trips = 5;
int: min_packages = 500;

% At least 30% of all trips must be by car:
% car_trips / (truck_trips + car_trips) >= 0.30
% To avoid division: 10*car_trips >= 3*(truck_trips + car_trips) -> 7*car_trips >= 3*truck_trips
int: car_share_num = 3;
int: car_share_den = 10;

var 0..max_truck_trips: truck_trips;
var 0..1000: car_trips;

constraint
  truck_capacity * truck_trips + car_capacity * car_trips >= min_packages;

constraint
  car_share_den * car_trips >= car_share_num * (truck_trips + car_trips);

var int: total_gas = truck_gas * truck_trips + car_gas * car_trips;

solve minimize total_gas;

output [
  "truck_trips = ", show(truck_trips), "\n",
  "car_trips = ", show(car_trips), "\n",
  "packages = ", show(truck_capacity * truck_trips + car_capacity * car_trips), "\n",
  "total_gas = ", show(total_gas), "\n"
];