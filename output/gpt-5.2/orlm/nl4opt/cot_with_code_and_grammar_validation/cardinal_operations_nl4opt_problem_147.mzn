% Parameters
int: car_capacity = 4;
int: car_pollution = 10;
int: bus_capacity = 20;
int: bus_pollution = 30;

int: min_employees = 300;
int: max_buses = 4;

% Variables
var 0..max_buses: buses;
var 0..(min_employees div car_capacity + 1000): cars;

% Constraints
constraint
  car_capacity * cars + bus_capacity * buses >= min_employees;

% Objective
solve minimize car_pollution * cars + bus_pollution * buses;