% Parameters
int: cap_small = 20;
int: cap_large = 50;
int: students_min = 500;
int: max_large_percent = 20;

% Variables
var 0..students_min: small_buses;
var 0..students_min: large_buses;
var 0..students_min: total_buses;

% Constraints
constraint total_buses = small_buses + large_buses;

constraint cap_small * small_buses + cap_large * large_buses >= students_min;

% At most 20% of buses are large:
% large_buses / total_buses <= 0.2  <=> 100*large_buses <= 20*total_buses
constraint 100 * large_buses <= max_large_percent * total_buses;

% Objective
solve minimize total_buses;