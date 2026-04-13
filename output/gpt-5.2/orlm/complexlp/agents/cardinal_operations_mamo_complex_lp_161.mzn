% Parameters
int: num_centers = 5;                 % Number of potential distribution centers
int: num_stores  = 7;                 % Number of retail stores

set of int: CENTERS = 1..num_centers; % Center index set
set of int: STORES  = 1..num_stores;  % Store index set

array[CENTERS] of int: open_cost =    % Fixed opening cost per center ($)
  [151000, 192000, 114000, 171000, 160000];

array[CENTERS, STORES] of int: ship_cost = % Unit transportation cost ($/unit)
  [| 5, 2, 3, 3, 3, 5, 4
   | 3, 5, 2, 4, 2, 4, 5
   | 1, 4, 2, 5, 4, 1, 1
   | 3, 3, 2, 4, 4, 3, 4
   | 4, 1, 3, 5, 3, 5, 1 |];

array[STORES] of int: demand =        % Demand per store (units)
  [566, 673, 787, 1000, 715, 413, 641];

array[CENTERS] of int: capacity =     % Supply capacity per center (units)
  [1576, 1364, 1697, 891, 1755];

int: total_demand = sum(s in STORES)(demand[s]); % Total demand (units)


% Variables
array[CENTERS] of var 0..1: open;     % 1 if center is opened, 0 otherwise

% ship[c,s] = units shipped from center c to store s
array[CENTERS, STORES] of var 0..total_demand: ship;

% Total cost = opening + shipping (upper bound uses worst-case unit cost)
var 0..(
  sum(c in CENTERS)(open_cost[c]) +
  total_demand * max([ship_cost[c,s] | c in CENTERS, s in STORES])
): total_cost;


% Constraints

% Meet each store's demand exactly (all demand must be satisfied)
constraint
  forall(s in STORES) (
    sum(c in CENTERS)(ship[c,s]) = demand[s]
  );

% Do not exceed each center's capacity; shipments allowed only if the center is open
constraint
  forall(c in CENTERS) (
    sum(s in STORES)(ship[c,s]) <= capacity[c] * open[c]
  );

% Define total_cost as opening costs plus transportation costs
constraint
  total_cost =
    sum(c in CENTERS)(open_cost[c] * open[c]) +
    sum(c in CENTERS, s in STORES)(ship_cost[c,s] * ship[c,s]);


% Objective
solve minimize total_cost;