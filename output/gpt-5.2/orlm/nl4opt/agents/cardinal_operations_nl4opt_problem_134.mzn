% Parameters
int: sedan_capacity  = 50;   % tourists served per sedan per day
int: bus_capacity    = 250;  % tourists served per bus per day
int: sedan_pollution = 10;   % pollution units per sedan per day
int: bus_pollution   = 40;   % pollution units per bus per day
int: max_pollution   = 800;  % maximum allowed pollution per day
int: min_customers   = 4600; % minimum customers to serve per day

% Variables
var 0..(max_pollution div sedan_pollution): num_sedans; % number of sedans to purchase
var 0..(max_pollution div bus_pollution):   num_buses;  % number of buses to purchase

% Constraints
% Pollution limit: total pollution from sedans and buses must not exceed the city's cap
constraint
  sedan_pollution * num_sedans + bus_pollution * num_buses <= max_pollution;

% Minimum service requirement: total seating capacity must serve at least the required customers
constraint
  sedan_capacity * num_sedans + bus_capacity * num_buses >= min_customers;

% Objective
solve minimize num_sedans + num_buses;