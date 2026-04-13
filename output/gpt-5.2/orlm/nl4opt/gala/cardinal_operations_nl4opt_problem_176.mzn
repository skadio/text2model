include "globals.mzn";

% Data (embedded from problem description)
int: freight_capacity = 5;      % tons per freight trip
int: air_capacity     = 3;      % tons per air trip
int: freight_cost     = 300;    % $ per freight trip
int: air_cost         = 550;    % $ per air trip

int: min_tons   = 200;          % must transport at least this many tons
int: budget     = 20000;        % max total cost
int: min_freight_trips = 5;     % at least this many freight trips
int: min_air_pct_num = 30;      % at least 30% by air (percent)

% Decision variables: number of trips (nonnegative integers)
var 0..10000: freight_trips;
var 0..10000: air_trips;

% Derived totals
var 0..100000: total_tons = freight_capacity * freight_trips + air_capacity * air_trips;
var 0..100000000: total_cost = freight_cost * freight_trips + air_cost * air_trips;

% Constraints
constraint total_tons >= min_tons;
constraint total_cost <= budget;
constraint freight_trips >= min_freight_trips;

% At least 30% of transported tons must be by air:
% air_tons / total_tons >= 0.30  ->  100*air_tons >= 30*total_tons
constraint 100 * (air_capacity * air_trips) >= min_air_pct_num * total_tons;

% Objective: minimize total number of trips
var 0..20000: total_trips = freight_trips + air_trips;
solve minimize total_trips;

output [
  "freight_trips = ", show(freight_trips), "\n",
  "air_trips = ", show(air_trips), "\n",
  "total_trips = ", show(total_trips), "\n",
  "total_tons = ", show(total_tons), "\n",
  "total_cost = ", show(total_cost), "\n",
  "air_tons = ", show(air_capacity * air_trips), "\n",
  "freight_tons = ", show(freight_capacity * freight_trips), "\n"
];