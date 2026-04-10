int: tractor_capacity = 40;
int: car_capacity = 20;
int: required_corn = 500;

var 0..ceil(required_corn div tractor_capacity + 100): tractors;
var 0..ceil(required_corn div car_capacity + 100): cars;

constraint car_capacity * cars + tractor_capacity * tractors >= required_corn;
constraint cars >= 2 * tractors;

var int: total_vehicles = tractors + cars;

solve minimize total_vehicles;

output [
  "tractors = ", show(tractors), "\n",
  "cars = ", show(cars), "\n",
  "total_vehicles = ", show(total_vehicles), "\n",
  "total_capacity = ", show(tractor_capacity * tractors + car_capacity * cars), "\n"
];