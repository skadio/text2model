% Parameters
int: num_centers = 9;                      % number of potential distribution centers
int: num_stores  = 7;                      % number of retail stores

set of int: CENTERS = 1..num_centers;
set of int: STORES  = 1..num_stores;

array[CENTERS] of int: open_cost =         % fixed opening cost per center ($)
  [151000, 192000, 114000, 171000, 160000, 120000, 182000, 186000, 174000];

array[CENTERS] of int: capacity =          % supply capacity per center (units)
  [1864, 1980, 814, 864, 1320, 1952, 1447, 1886, 1962];

array[STORES] of int: demand =             % demand per store (units)
  [695, 737, 452, 616, 587, 779, 892];

% NOTE: The full 9x7 transportation cost matrix was not provided in the prompt
% (only examples like "From Center 1: $3 to Store 1, $5 to Store 2, etc.").
% To keep the model runnable, we embed a placeholder matrix.
% Replace these values with the actual costs when available.
array[CENTERS, STORES] of int: ship_cost =
  array2d(CENTERS, STORES,
  [
    3, 5, 4, 6, 7, 5, 6,   % Center 1 -> Stores 1..7
    2, 4, 3, 5, 6, 4, 5,   % Center 2
    4, 6, 5, 7, 8, 6, 7,   % Center 3
    5, 7, 6, 8, 9, 7, 8,   % Center 4
    3, 5, 4, 6, 7, 5, 6,   % Center 5
    2, 4, 3, 5, 6, 4, 5,   % Center 6
    4, 6, 5, 7, 8, 6, 7,   % Center 7
    5, 7, 6, 8, 9, 7, 8,   % Center 8
    3, 5, 4, 6, 7, 5, 6    % Center 9
  ]);

int: total_demand = sum(s in STORES)(demand[s]);  % useful bound


% Variables
array[CENTERS] of var bool: open;                 % true if center is opened
array[CENTERS, STORES] of var 0..total_demand: ship;  % units shipped from center c to store s

var int: total_open_cost;                         % sum of opening costs
var int: total_ship_cost;                         % sum of transportation costs
var int: total_cost;                              % objective value


% Constraints
% Link facility opening decision to its shipped quantity (capacity active only if open)
constraint
  forall(c in CENTERS)(
    sum(s in STORES)(ship[c,s]) <= capacity[c] * bool2int(open[c])
  );

% Satisfy each store's demand exactly
constraint
  forall(s in STORES)(
    sum(c in CENTERS)(ship[c,s]) = demand[s]
  );

% Per-arc simple upper bounds (nonnegativity is ensured by ship domain)
constraint
  forall(c in CENTERS, s in STORES)(
    ship[c,s] <= demand[s]
  );

% Aggregate costs
constraint
  total_open_cost = sum(c in CENTERS)(open_cost[c] * bool2int(open[c]));

constraint
  total_ship_cost = sum(c in CENTERS, s in STORES)(ship_cost[c,s] * ship[c,s]);

constraint
  total_cost = total_open_cost + total_ship_cost;


% Objective
solve minimize total_cost;