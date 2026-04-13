% Parameters
int: car_capacity = 4;              % employees per car
int: car_pollution = 10;            % pollution units per car
int: bus_capacity = 20;             % employees per bus
int: bus_pollution = 30;            % pollution units per bus
int: min_employees = 300;           % minimum employees to transport
int: max_buses = 4;                 % maximum buses allowed

% Variables
% Upper bound: in the worst case, cars alone carry everyone.
% Use ceil(min_employees / car_capacity) computed as (min_employees + car_capacity - 1) div car_capacity.
var 0..((min_employees + car_capacity - 1) div car_capacity): num_cars;
var 0..max_buses: num_buses;

% Constraints
% Meet minimum transportation demand (at least min_employees employees transported)
constraint
  car_capacity * num_cars + bus_capacity * num_buses >= min_employees;

% Respect maximum number of buses allowed (redundant due to variable domain, kept for clarity)
constraint
  num_buses <= max_buses;

% Objective
solve minimize car_pollution * num_cars + bus_pollution * num_buses;