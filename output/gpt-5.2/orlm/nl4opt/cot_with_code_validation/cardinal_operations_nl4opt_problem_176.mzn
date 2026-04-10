% Parameters
int: freight_capacity = 5;      % tons per freight trip
int: air_capacity = 3;          % tons per air trip
int: freight_cost = 300;        % $ per freight trip
int: air_cost = 550;            % $ per air trip

int: min_tons = 200;            % minimum tons to transport
int: budget = 20000;            % maximum budget $
int: min_freight_trips = 5;     % minimum freight trips

int: air_ratio_num = 30;        % at least 30% by air
int: air_ratio_den = 100;

int: max_freight_trips = budget div freight_cost;
int: max_air_trips = budget div air_cost;

% Variables
var 0..max_freight_trips: freight_trips;
var 0..max_air_trips: air_trips;

var 0..(freight_capacity * max_freight_trips + air_capacity * max_air_trips): total_tons;
var 0..budget: total_cost;
var 0..(max_freight_trips + max_air_trips): total_trips;

% Constraints
constraint total_tons = freight_capacity * freight_trips + air_capacity * air_trips;
constraint total_cost = freight_cost * freight_trips + air_cost * air_trips;
constraint total_trips = freight_trips + air_trips;

constraint total_tons >= min_tons;
constraint total_cost <= budget;

constraint freight_trips >= min_freight_trips;

% At least 30% of transported tons must be by air:
% air_capacity*air_trips >= 0.30 * total_tons
constraint air_ratio_den * air_capacity * air_trips >= air_ratio_num * total_tons;

% Objective
solve minimize total_trips;