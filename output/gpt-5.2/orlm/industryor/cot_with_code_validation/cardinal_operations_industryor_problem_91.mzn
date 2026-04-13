% Parameters
int: students = 400;
int: max_buses = 10;
int: max_minibuses = 8;
int: seats_bus = 50;
int: seats_minibus = 40;
int: drivers = 9;
int: cost_bus = 800;
int: cost_minibus = 600;

% Variables
var 0..max_buses: x_buses;
var 0..max_minibuses: x_minibuses;

% Constraints
constraint x_buses + x_minibuses <= drivers;

constraint seats_bus * x_buses + seats_minibus * x_minibuses >= students;

% Objective
solve minimize cost_bus * x_buses + cost_minibus * x_minibuses;