% Parameters (with values embedded)
int: taxi_capacity = 2;
int: car_capacity  = 3;
int: min_employees = 500;
float: max_car_fraction = 0.6;
int: min_car_rides = 30;

% Variables
var 0..1000: taxi_rides;
var 0..1000: car_rides;

% Constraints
constraint car_rides >= min_car_rides;
constraint taxi_capacity * taxi_rides + car_capacity * car_rides >= min_employees;

% At most 60% of the rides can be company car rides:
% car_rides <= 0.6 * (taxi_rides + car_rides)
% Multiply by 10 to keep it integer: 10*car <= 6*(taxi+car) -> 4*car <= 6*taxi
constraint 4 * car_rides <= 6 * taxi_rides;

% Objective
solve minimize taxi_rides;

output [
  "taxi_rides = ", show(taxi_rides), "\n",
  "car_rides = ", show(car_rides), "\n",
  "total_rides = ", show(taxi_rides + car_rides), "\n",
  "employees_moved = ", show(taxi_capacity * taxi_rides + car_capacity * car_rides), "\n"
];