% Parameters
int: num_centers = 8;                 % Number of potential distribution centers
int: num_stores  = 5;                 % Number of retail stores

set of int: CENTERS = 1..num_centers; % Index set for centers
set of int: STORES  = 1..num_stores;  % Index set for stores

array[CENTERS] of int: open_cost =    % Fixed opening cost for each center
  [151000, 192000, 114000, 171000, 160000, 120000, 182000, 186000];

array[CENTERS, STORES] of int: ship_cost = % Unit transportation costs
  array2d(CENTERS, STORES,
    [
      3, 3, 5, 4, 3,   % Center 1 -> Stores 1..5
      5, 2, 4, 2, 4,   % Center 2
      5, 1, 4, 2, 5,   % Center 3
      4, 1, 1, 3, 3,   % Center 4
      2, 4, 4, 3, 4,   % Center 5
      4, 1, 3, 5, 3,   % Center 6
      5, 1, 2, 4, 1,   % Center 7
      4, 2, 2, 1, 2    % Center 8
    ]);

array[STORES] of int: demand =        % Demand for each store
  [964, 739, 491, 766, 854];

array[CENTERS] of int: capacity =     % Supply capacity of each center
  [1308, 1575, 834, 1005, 1904, 1825, 1821, 1365];

int: total_demand = sum(s in STORES)(demand[s]); % Used for variable bounds

% Variables
array[CENTERS] of var bool: open;     % true if center is opened

array[CENTERS, STORES] of var 0..total_demand: flow;  % Units shipped center->store

% Upper bound: all opening costs + worst-case unit shipping cost * total demand
var 0..sum(c in CENTERS)(open_cost[c]) + total_demand * max(c in CENTERS, s in STORES)(ship_cost[c,s]): total_cost;

% Constraints

% Demand fulfillment: each store must receive exactly its demand
constraint
  forall(s in STORES) (
    sum(c in CENTERS)(flow[c,s]) = demand[s]
  );

% Capacity and opening linkage: a center can ship only if opened, and within capacity
constraint
  forall(c in CENTERS) (
    sum(s in STORES)(flow[c,s]) <= capacity[c] * bool2int(open[c])
  );

% Total cost definition: opening costs + per-unit shipping costs
constraint
  total_cost =
    sum(c in CENTERS)(open_cost[c] * bool2int(open[c])) +
    sum(c in CENTERS, s in STORES)(ship_cost[c,s] * flow[c,s]);

% Objective
solve minimize total_cost;