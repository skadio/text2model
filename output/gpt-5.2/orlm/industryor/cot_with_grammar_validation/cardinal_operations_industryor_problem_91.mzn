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
var 0..max_buses: x_buses;
var 0..max_minibuses: x_minibuses;

var 0..(max_buses + max_minibuses): x_total_vehicles;
var 0..(max_buses * seats_bus + max_minibuses * seats_minibus): x_total_seats;
var 0..(max_buses * cost_bus + max_minibuses * cost_minibus): x_total_cost;

% Constraints
constraint x_total_vehicles = x_buses + x_minibuses;
constraint x_total_vehicles <= drivers;

constraint x_total_seats = seats_bus * x_buses + seats_minibus * x_minibuses;
constraint x_total_seats >= students;

constraint x_total_cost = cost_bus * x_buses + cost_minibus * x_minibuses;

% Objective
solve minimize x_total_cost;