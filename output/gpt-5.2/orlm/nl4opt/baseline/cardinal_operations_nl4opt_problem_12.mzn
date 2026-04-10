% Embedded data
int: van_capacity = 6;
int: car_capacity = 3;
int: required_voters = 200;

% Decision variables
var 0..required_voters: vans;
var 0..required_voters: cars;

% Constraints
constraint van_capacity * vans + car_capacity * cars >= required_voters;

% At most 30% of vehicles are vans:
% vans / (vans + cars) <= 0.30  <=>  10*vans <= 3*(vans+cars)  <=>  7*vans <= 3*cars
% Also avoids division by zero; if cars=0 then vans must be 0, which cannot meet demand.
constraint 7 * vans <= 3 * cars;

% Objective: minimize number of cars used
solve minimize cars;

output [
  "vans = ", show(vans), "\n",
  "cars = ", show(cars), "\n",
  "total_vehicles = ", show(vans + cars), "\n",
  "capacity = ", show(van_capacity*vans + car_capacity*cars), "\n"
];