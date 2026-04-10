include "globals.mzn";

% Data (embedded from the problem statement)
int: van_cap = 6;
int: car_cap = 3;
int: demand = 200;
int: van_percent_max = 30; % percent

% Decision variables
var 0..demand: vans;
var 0..demand: cars;

% Capacity requirement
constraint van_cap * vans + car_cap * cars >= demand;

% At most 30% of vehicles are vans:
% vans / (vans + cars) <= 0.30  ->  100*vans <= 30*(vans+cars)
constraint 100 * vans <= van_percent_max * (vans + cars);

% Objective: minimize number of cars used
solve minimize cars;

output [
  "vans = ", show(vans), "\n",
  "cars = ", show(cars), "\n",
  "total_vehicles = ", show(vans + cars), "\n",
  "total_capacity = ", show(van_cap * vans + car_cap * cars), "\n"
];