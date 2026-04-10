int: car_capacity = 4;
int: bus_capacity = 20;

int: car_pollution = 10;
int: bus_pollution = 30;

int: min_employees = 300;
int: max_buses = 4;

var 0..1000: cars;
var 0..max_buses: buses;

constraint car_capacity * cars + bus_capacity * buses >= min_employees;

var int: total_pollution = car_pollution * cars + bus_pollution * buses;

solve minimize total_pollution;

output [
  "cars=", show(cars), "\n",
  "buses=", show(buses), "\n",
  "employees_transported=", show(car_capacity * cars + bus_capacity * buses), "\n",
  "total_pollution=", show(total_pollution), "\n"
];