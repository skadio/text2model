% Parameters
int: sedan_capacity = 50;          % tourists/day served by one sedan
int: bus_capacity = 250;           % tourists/day served by one bus
int: sedan_pollution = 10;         % pollution units/day produced by one sedan
int: bus_pollution = 40;           % pollution units/day produced by one bus
int: max_pollution = 800;          % maximum allowed pollution units/day
int: min_customers = 4600;         % minimum tourists/day that must be served

% Simple safe upper bounds (used to bound decision variables)
int: max_sedans = max_pollution div sedan_pollution;  % if only sedans were bought
int: max_buses  = max_pollution div bus_pollution;    % if only buses were bought

% Variables
var 0..max_sedans: num_sedans;     % number of sedans to purchase
var 0..max_buses:  num_buses;      % number of buses to purchase
var 0..(max_sedans + max_buses): total_vehicles;  % total vehicles purchased

% Constraints

% --- Define total vehicles purchased ---
constraint
  total_vehicles = num_sedans + num_buses;

% --- Pollution limit (daily emissions must not exceed the city's cap) ---
constraint
  sedan_pollution * num_sedans + bus_pollution * num_buses <= max_pollution;

% --- Minimum service capacity (must serve at least the required customers/day) ---
constraint
  sedan_capacity * num_sedans + bus_capacity * num_buses >= min_customers;

% Objective
solve minimize total_vehicles;

% Optional output for clarity
output [
  "num_sedans = ", show(num_sedans), "\n",
  "num_buses  = ", show(num_buses), "\n",
  "total_vehicles = ", show(total_vehicles), "\n"
];