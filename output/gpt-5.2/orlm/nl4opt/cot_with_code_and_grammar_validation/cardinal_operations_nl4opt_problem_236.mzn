% Parameters
int: dine_capacity = 100;
int: dine_employees = 8;
int: truck_capacity = 50;
int: truck_employees = 3;

int: min_sandwiches = 500;
int: max_employees = 35;

int: max_dine = max_employees div dine_employees;
int: max_truck = max_employees div truck_employees;

% Variables
var 0..max_dine: dine;
var 0..max_truck: truck;

% Constraints
constraint dine_employees * dine + truck_employees * truck <= max_employees;
constraint dine_capacity * dine + truck_capacity * truck >= min_sandwiches;

% Objective
solve minimize dine + truck;