% Parameters
int: taxi_capacity = 2;
int: car_capacity = 3;

float: max_car_fraction = 0.60;
int: min_car_rides = 30;

int: min_employees = 500;

% Variables
var 0..ceil(int2float(min_employees) / int2float(taxi_capacity)): taxi_rides;
var min_car_rides..ceil(int2float(min_employees) / int2float(car_capacity)): car_rides;

% Constraints
constraint
  taxi_capacity * taxi_rides + car_capacity * car_rides >= min_employees;

% At most 60% of rides are company car rides:
% car_rides <= 0.60 * (taxi_rides + car_rides)
% <=> (1 - 0.60) * car_rides <= 0.60 * taxi_rides
% <=> 0.40 * car_rides <= 0.60 * taxi_rides
% Multiply by 10 to keep it integer: 4*car_rides <= 6*taxi_rides
constraint
  4 * car_rides <= 6 * taxi_rides;

% Objective
solve minimize taxi_rides;