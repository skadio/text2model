% Parameters
int: freight_capacity = 5;      % tons per freight trip
int: air_capacity = 3;          % tons per air trip
int: freight_cost = 300;        % $ per freight trip
int: air_cost = 550;            % $ per air trip
int: min_tons = 200;            % tons
int: budget = 20000;            % $
int: min_freight_trips = 5;     % trips
int: air_share_num = 30;        % 30%
int: air_share_den = 100;

% Variables
int: max_air_trips = budget div air_cost;         % safe upper bound
int: max_freight_trips = budget div freight_cost; % safe upper bound
var 0..max_freight_trips: freight_trips;
var 0..max_air_trips: air_trips;

% Constraints
constraint freight_trips >= min_freight_trips;

% total tons shipped must be at least min_tons
constraint freight_capacity * freight_trips + air_capacity * air_trips >= min_tons;

% budget constraint
constraint freight_cost * freight_trips + air_cost * air_trips <= budget;

% at least 30% of tons shipped must be by air:
% air_tons >= 0.30 * total_tons  =>  100*air_tons >= 30*total_tons
constraint air_share_den * (air_capacity * air_trips)
        >= air_share_num * (freight_capacity * freight_trips + air_capacity * air_trips);

% Objective
solve minimize freight_trips + air_trips;