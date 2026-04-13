% Parameters
int: small_capacity = 20;
int: large_capacity = 50;
int: min_students = 500;
int: max_large_percent = 20; % percent

% Variables
var 0..ceil(min_students div small_capacity): small_buses;
var 0..ceil(min_students div large_capacity): large_buses;
var 0..ceil(min_students div min(small_capacity, large_capacity)): total_buses;

% Constraints
constraint total_buses = small_buses + large_buses;

constraint small_capacity * small_buses + large_capacity * large_buses >= min_students;

% max 20% of buses can be large: large_buses / total_buses <= 0.2  ==>  5*large_buses <= total_buses
constraint 5 * large_buses <= total_buses;

% Objective
solve minimize total_buses;