% Parameters
int: freight_capacity = 5;         % tons per freight trip
int: air_capacity = 3;             % tons per air trip
int: freight_cost = 300;           % $ per freight trip
int: air_cost = 550;               % $ per air trip
int: min_tons = 200;               % at least this many tons shipped
int: budget = 20000;               % total cost budget
int: min_freight_trips = 5;        % at least this many freight trips

% Variables
var 0..10000: x_freight;           % number of freight trips
var 0..10000: x_air;               % number of air trips

% Constraints
constraint x_freight >= min_freight_trips;

% total tons shipped
constraint freight_capacity * x_freight + air_capacity * x_air >= min_tons;

% budget limit
constraint freight_cost * x_freight + air_cost * x_air <= budget;

% at least 30% of tons by air:
% air_capacity*x_air >= 0.3*(freight_capacity*x_freight + air_capacity*x_air)
% Multiply by 10 to avoid floats: 10*air >= 3*(total)
constraint 10 * air_capacity * x_air >= 3 * (freight_capacity * x_freight + air_capacity * x_air);

% Objective
solve minimize (x_freight + x_air);