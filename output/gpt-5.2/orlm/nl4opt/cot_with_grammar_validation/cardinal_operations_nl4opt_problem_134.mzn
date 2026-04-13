% Parameters
int: sedan_capacity = 50;
int: bus_capacity = 250;

int: sedan_pollution = 10;
int: bus_pollution = 40;

int: max_pollution = 800;
int: min_customers = 4600;

% Variables
var 0..(max_pollution div sedan_pollution): sedans;
var 0..(max_pollution div bus_pollution): buses;

% Constraints
constraint
  sedan_pollution * sedans + bus_pollution * buses <= max_pollution;

constraint
  sedan_capacity * sedans + bus_capacity * buses >= min_customers;

% Objective
solve minimize sedans + buses;