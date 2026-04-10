% Parameters
int: dine_capacity = 100;
int: dine_employees = 8;
int: truck_capacity = 50;
int: truck_employees = 3;

int: min_sandwiches = 500;
int: max_employees = 35;

% Variables
var 0..(max_employees div dine_employees): dine_in;
var 0..(max_employees div truck_employees): food_truck;

% Constraints
constraint
  dine_capacity * dine_in + truck_capacity * food_truck >= min_sandwiches;

constraint
  dine_employees * dine_in + truck_employees * food_truck <= max_employees;

% Objective
solve minimize dine_in + food_truck;