% Parameters
int: students = 400;

int: max_buses = 10;
int: max_minibuses = 8;
int: drivers = 9;

int: seats_bus = 50;
int: seats_minibus = 40;

int: cost_bus = 800;
int: cost_minibus = 600;

% Variables
var 0..max_buses: n_buses;
var 0..max_minibuses: n_minibuses;

% Constraints
constraint n_buses + n_minibuses <= drivers;
constraint seats_bus * n_buses + seats_minibus * n_minibuses >= students;

% Objective
solve minimize cost_bus * n_buses + cost_minibus * n_minibuses;