% Parameters
int: freight_capacity = 5;        % tons per freight trip
int: air_capacity     = 3;        % tons per air trip

int: freight_cost = 300;          % $ per freight trip
int: air_cost     = 550;          % $ per air trip

int: min_tons_total = 200;        % minimum total tons to transport
int: budget         = 20000;      % maximum total budget in $

int: min_freight_trips = 5;       % at least this many freight trips
int: air_share_percent = 30;      % at least this % of total tons via air

% Safe upper bounds derived from budget (costs are positive)
int: max_freight_trips = budget div freight_cost;
int: max_air_trips     = budget div air_cost;

% Variables
var 0..max_freight_trips: freight_trips;  % number of freight trips
var 0..max_air_trips: air_trips;          % number of air trips

% Constraints

% --- Basic feasibility: minimum freight trips ---
constraint freight_trips >= min_freight_trips;

% --- Total transported tons requirement ---
constraint
  freight_capacity * freight_trips + air_capacity * air_trips >= min_tons_total;

% --- Budget limit ---
constraint
  freight_cost * freight_trips + air_cost * air_trips <= budget;

% --- Minimum air share (at least 30% of total tons via air) ---
% 100 * air_tons >= air_share_percent * total_tons  (keeps it integral)
constraint
  100 * (air_capacity * air_trips)
    >= air_share_percent * (freight_capacity * freight_trips + air_capacity * air_trips);

% Objective
solve minimize freight_trips + air_trips;

output [
  "freight_trips=", show(freight_trips), "\n",
  "air_trips=", show(air_trips), "\n",
  "total_trips=", show(freight_trips + air_trips), "\n",
  "total_tons=", show(freight_capacity * freight_trips + air_capacity * air_trips), "\n",
  "air_tons=", show(air_capacity * air_trips), "\n",
  "total_cost=", show(freight_cost * freight_trips + air_cost * air_trips), "\n"
];