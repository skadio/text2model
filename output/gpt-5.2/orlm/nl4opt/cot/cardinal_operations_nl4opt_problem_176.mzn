% Parameters (with values embedded)
int: freight_capacity = 5;      % tons per freight trip
int: air_capacity = 3;          % tons per air trip
int: freight_cost = 300;        % $ per freight trip
int: air_cost = 550;            % $ per air trip
int: min_tons = 200;            % tons to transport (at least)
int: budget = 20000;            % $ budget (at most)
int: min_freight_trips = 5;     % at least 5 freight trips

% Variables
% Upper bounds derived from budget (costs are positive)
var 0..(budget div freight_cost): freight_trips;
var 0..(budget div air_cost): air_trips;

% Constraints
constraint freight_trips >= min_freight_trips;

% Total tons requirement
constraint freight_capacity * freight_trips + air_capacity * air_trips >= min_tons;

% Budget constraint
constraint freight_cost * freight_trips + air_cost * air_trips <= budget;

% At least 30% of transported tons must be via air:
% air_tons >= 0.3 * total_tons  <=>  10*air_tons >= 3*total_tons
% where air_tons = 3*air_trips and total_tons = 5*freight_trips + 3*air_trips
constraint 10 * (air_capacity * air_trips) >= 3 * (freight_capacity * freight_trips + air_capacity * air_trips);

% Objective
solve minimize freight_trips + air_trips;