% Candle transport scheduling (embedded data)

int: freight_cap = 5;      % tons per freight trip
int: air_cap = 3;          % tons per air trip
int: freight_cost = 300;   % $ per freight trip
int: air_cost = 550;       % $ per air trip

int: min_tons = 200;       % at least this many tons
int: budget = 20000;       % total cost limit
int: min_freight_trips = 5;

% At least 30% of transported tons must be by air:
% air_tons >= 0.30 * total_tons  <=>  10*air_tons >= 3*(air_tons + freight_tons)
% with air_tons = air_cap*air_trips, freight_tons = freight_cap*freight_trips
% simplifies to: 7*air_tons >= 3*freight_tons
% -> 7*(3*air_trips) >= 3*(5*freight_trips)  <=>  21*air_trips >= 15*freight_trips

% Decision variables
var 0..10000: freight_trips;
var 0..10000: air_trips;

% Derived expressions
var int: total_tons = freight_cap * freight_trips + air_cap * air_trips;
var int: total_cost = freight_cost * freight_trips + air_cost * air_trips;
var int: total_trips = freight_trips + air_trips;

% Constraints
constraint freight_trips >= min_freight_trips;
constraint total_tons >= min_tons;
constraint total_cost <= budget;
constraint 21 * air_trips >= 15 * freight_trips; % air ton share >= 30%

% Objective: minimize total number of trips
solve minimize total_trips;

output [
  "freight_trips=", show(freight_trips), "\n",
  "air_trips=", show(air_trips), "\n",
  "total_trips=", show(total_trips), "\n",
  "total_tons=", show(total_tons), "\n",
  "total_cost=", show(total_cost), "\n"
];