include "globals.mzn";

% Data (embedded from problem statement)
int: taxi_capacity = 2;
int: car_capacity  = 3;

int: min_employees = 500;
int: min_car_rides = 30;

% At most 60% of rides can be company cars:
% car_rides <= 0.6 * (taxi_rides + car_rides)
% => 10*car_rides <= 6*(taxi_rides + car_rides)
% => 4*car_rides <= 6*taxi_rides
int: pct_num = 6;
int: pct_den = 10;

% Decision variables
var 0..10000: taxi_rides;
var 0..10000: car_rides;

% Constraints
constraint car_rides >= min_car_rides;
constraint pct_den * car_rides <= pct_num * (taxi_rides + car_rides);

constraint taxi_capacity * taxi_rides + car_capacity * car_rides >= min_employees;

% Objective: minimize the number of taxi rides
solve minimize taxi_rides;

output [
  "Taxi rides = ", show(taxi_rides), "\n",
  "Company car rides = ", show(car_rides), "\n",
  "Total rides = ", show(taxi_rides + car_rides), "\n",
  "Employees capacity = ", show(taxi_capacity * taxi_rides + car_capacity * car_rides), "\n"
];