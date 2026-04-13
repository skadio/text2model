% Parameters
int: sedan_capacity = 50;
int: bus_capacity = 250;
int: sedan_pollution = 10;
int: bus_pollution = 40;

int: max_pollution = 800;
int: min_customers = 4600;

int: max_sedans = max_pollution div sedan_pollution; % 80
int: max_buses = max_pollution div bus_pollution;    % 20

% Variables
var 0..max_sedans: sedans;
var 0..max_buses: buses;
var 0..(max_sedans + max_buses): total_vehicles;

% Constraints
constraint sedan_pollution * sedans + bus_pollution * buses <= max_pollution;
constraint sedan_capacity * sedans + bus_capacity * buses >= min_customers;

constraint total_vehicles = sedans + buses;

% Objective
solve minimize total_vehicles;