% Transport planning: minimize pollution while transporting enough employees.

% Data (embedded as required)
int: car_capacity = 4;
int: car_pollution = 10;

int: bus_capacity = 20;
int: bus_pollution = 30;

int: required_employees = 300;
int: max_buses = 4;

% Decision variables
var 0..(required_employees div car_capacity + 100): cars; % safe upper bound
var 0..max_buses: buses;

% Constraints
constraint car_capacity * cars + bus_capacity * buses >= required_employees;

% Objective: minimize total pollution
var int: total_pollution = car_pollution * cars + bus_pollution * buses;

solve minimize total_pollution;

output [
  "Cars = ", show(cars), "\n",
  "Buses = ", show(buses), "\n",
  "Employees transported = ", show(car_capacity * cars + bus_capacity * buses), "\n",
  "Total pollution = ", show(total_pollution), "\n"
];