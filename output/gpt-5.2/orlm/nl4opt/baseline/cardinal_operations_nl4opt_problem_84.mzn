% Daycare transportation scheduling

var 0..200: buses;          % number of buses
var 0..200: cars;           % number of personal cars

constraint 9 * buses + 4 * cars >= 100;   % pick up at least 100 children
constraint buses > cars;                  % more buses than personal cars
constraint cars >= 5;                     % at least 5 personal cars

var 0..400: total_vehicles = buses + cars;

solve minimize total_vehicles;

output [
  "buses = ", show(buses), "\n",
  "cars = ", show(cars), "\n",
  "total_vehicles = ", show(total_vehicles), "\n",
  "capacity = ", show(9*buses + 4*cars), "\n"
];