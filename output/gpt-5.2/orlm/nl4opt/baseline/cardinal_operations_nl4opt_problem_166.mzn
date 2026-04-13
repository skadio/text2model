% Factory rides optimization: minimize number of taxi rides

int: employees_needed = 500;
int: taxi_capacity = 2;
int: car_capacity  = 3;

float: max_car_fraction = 0.60;  % at most 60% of rides are company cars
int: min_car_rides = 30;

var 0..10000: taxi_rides;
var 0..10000: car_rides;

% Transport at least the required number of employees
constraint taxi_capacity * taxi_rides + car_capacity * car_rides >= employees_needed;

% At most 60% of the rides can be company car rides:
% car_rides <= 0.6 * (taxi_rides + car_rides)
% Multiply by 10 to keep it integer: 10*car <= 6*(taxi+car) -> 4*car <= 6*taxi -> 2*car <= 3*taxi
constraint 2 * car_rides <= 3 * taxi_rides;

% At least 30 company car rides
constraint car_rides >= min_car_rides;

solve minimize taxi_rides;

output [
  "taxi_rides = ", show(taxi_rides), "\n",
  "car_rides  = ", show(car_rides), "\n",
  "total_rides = ", show(taxi_rides + car_rides), "\n",
  "employees_transported = ", show(taxi_capacity * taxi_rides + car_capacity * car_rides), "\n"
];