% Parameters
int: num_centers = 9;              % Number of potential distribution centers
int: num_stores  = 8;              % Number of retail stores

set of int: CENTERS = 1..num_centers;
set of int: STORES  = 1..num_stores;

array[CENTERS] of int: opening_cost =
  [151000, 192000, 114000, 171000, 160000, 120000, 182000, 186000, 174000]; % $ to open each center

% Demand per store (units)
array[STORES] of int: demand =
  [414, 523, 612, 700, 755, 810, 890, 920];

% Capacity per center (units)
array[CENTERS] of int: capacity =
  [1030, 1105, 1240, 1325, 1450, 1560, 1680, 1795, 1962];

% Transportation cost per unit from center i to store j ($/unit)
array[CENTERS, STORES] of int: transport_cost =
  array2d(CENTERS, STORES,
  [
    3, 4, 5, 6, 7, 6, 5, 4,   % Center 1 -> Stores 1..8
    6, 5, 4, 7, 8, 6, 5, 4,   % Center 2 -> Stores 1..8
    5, 6, 3, 4, 6, 7, 5, 6,   % Center 3 -> Stores 1..8
    7, 6, 5, 3, 4, 6, 7, 5,   % Center 4 -> Stores 1..8
    6, 7, 6, 5, 3, 4, 6, 7,   % Center 5 -> Stores 1..8
    4, 5, 6, 7, 6, 3, 4, 5,   % Center 6 -> Stores 1..8
    5, 4, 7, 6, 7, 5, 3, 4,   % Center 7 -> Stores 1..8
    6, 5, 4, 6, 5, 6, 4, 3,   % Center 8 -> Stores 1..8
    7, 6, 5, 4, 6, 7, 5, 4    % Center 9 -> Stores 1..8
  ]);

% Helpful derived bounds
int: total_demand = sum(j in STORES)(demand[j]); % total units required across all stores

% Variables
array[CENTERS] of var 0..1: open;  % 1 if center i is opened

% ship[i,j] = units shipped from center i to store j
array[CENTERS, STORES] of var 0..total_demand: ship;

% Total cost (opening + transport), explicitly bounded (finite bound for the solver)
int: max_open_cost = sum(i in CENTERS)(opening_cost[i]);
int: max_unit_cost = max([transport_cost[i,j] | i in CENTERS, j in STORES]);
int: max_total_cost = max_open_cost + total_demand * max_unit_cost;

var 0..max_total_cost: total_cost; % objective value (minimum)

% Constraints

% Demand satisfaction: each store receives exactly its demand
constraint
  forall(j in STORES) (
    sum(i in CENTERS)(ship[i,j]) = demand[j]
  );

% Capacity + activation: if not open, cannot ship; if open, total shipped <= capacity
constraint
  forall(i in CENTERS) (
    sum(j in STORES)(ship[i,j]) <= capacity[i] * open[i]
  );

% Define total cost = opening costs + per-unit transport costs * shipped units
constraint
  total_cost =
    sum(i in CENTERS)(opening_cost[i] * open[i]) +
    sum(i in CENTERS, j in STORES)(transport_cost[i,j] * ship[i,j]);

% Objective
solve minimize total_cost;