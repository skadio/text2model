% Parameters (with values embedded)
int: sandwich_dinein = 100;
int: emp_dinein = 8;
int: sandwich_truck = 50;
int: emp_truck = 3;

int: min_sandwiches = 500;
int: max_employees = 35;

% Variables
var 0..(max_employees div emp_dinein): x_dinein;  % number of dine-in stores
var 0..(max_employees div emp_truck): x_truck;    % number of food-trucks

% Constraints
constraint sandwich_dinein * x_dinein + sandwich_truck * x_truck >= min_sandwiches;
constraint emp_dinein * x_dinein + emp_truck * x_truck <= max_employees;

% Objective
solve minimize x_dinein + x_truck;