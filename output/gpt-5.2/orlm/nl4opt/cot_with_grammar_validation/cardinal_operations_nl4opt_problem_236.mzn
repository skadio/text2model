% Parameters
int: sandwiches_dinein = 100;
int: sandwiches_truck = 50;
int: employees_dinein = 8;
int: employees_truck = 3;

int: min_sandwiches = 500;
int: max_employees = 35;

% Variables
var 0..(max_employees div employees_dinein): x_dinein;
var 0..(max_employees div employees_truck): x_truck;

% Constraints
constraint sandwiches_dinein * x_dinein + sandwiches_truck * x_truck >= min_sandwiches;
constraint employees_dinein * x_dinein + employees_truck * x_truck <= max_employees;

% Objective
solve minimize x_dinein + x_truck;