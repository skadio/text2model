% Parameters
int: small_bus_capacity = 20;              % Students per small bus
int: large_bus_capacity = 50;              % Students per large bus
int: min_students = 500;                   % Minimum number of students to transport
float: max_large_bus_fraction = 0.20;      % Maximum fraction of buses that can be large

% Variables
% Upper bounds based on worst-case (all of one type) to ensure finite domains.
var 0..ceil(int2float(min_students) / int2float(small_bus_capacity)): num_small_buses; % # small buses hired
var 0..ceil(int2float(min_students) / int2float(large_bus_capacity)): num_large_buses; % # large buses hired
var 0..ceil(int2float(min_students) / int2float(min(small_bus_capacity, large_bus_capacity))): total_buses; % total buses hired

% Constraints
% Total buses definition
constraint
  total_buses = num_small_buses + num_large_buses;

% Minimum student capacity requirement
constraint
  small_bus_capacity * num_small_buses + large_bus_capacity * num_large_buses >= min_students;

% Large-bus fraction (at most max_large_bus_fraction of all buses are large)
% Implemented using floats as given.
constraint
  int2float(num_large_buses) <= max_large_bus_fraction * int2float(total_buses);

% Objective
solve minimize total_buses;