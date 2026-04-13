% Parameters
int: num_centers = 8;              % Number of potential distribution centers
int: num_stores  = 9;              % Number of retail stores

set of int: CENTERS = 1..num_centers;
set of int: STORES  = 1..num_stores;

array[CENTERS] of int: open_cost =  % Fixed opening cost per center
  [151000, 192000, 114000, 171000, 160000, 120000, 182000, 186000];

array[STORES] of int: demand =     % Demand per store (units)
  [779, 892, 440, 556, 414, 464, 920, 743, 528];

array[CENTERS] of int: capacity =  % Supply capacity per center (units)
  [1447, 1886, 1962, 1392, 1191, 1218, 1088, 1178];

% Transportation cost per unit from each center to each store.
% NOTE: The problem statement does not provide the exact 8x9 matrix values,
% only a range ("$1 to $5" or "$2 to $5"). A concrete matrix is required
% to solve the optimization. Please fill in the actual costs below.
array[CENTERS, STORES] of int: ship_cost =
  array2d(CENTERS, STORES,
    [
      % Center 1 -> Stores 1..9
      0, 0, 0, 0, 0, 0, 0, 0, 0,
      % Center 2 -> Stores 1..9
      0, 0, 0, 0, 0, 0, 0, 0, 0,
      % Center 3 -> Stores 1..9
      0, 0, 0, 0, 0, 0, 0, 0, 0,
      % Center 4 -> Stores 1..9
      0, 0, 0, 0, 0, 0, 0, 0, 0,
      % Center 5 -> Stores 1..9
      0, 0, 0, 0, 0, 0, 0, 0, 0,
      % Center 6 -> Stores 1..9
      0, 0, 0, 0, 0, 0, 0, 0, 0,
      % Center 7 -> Stores 1..9
      0, 0, 0, 0, 0, 0, 0, 0, 0,
      % Center 8 -> Stores 1..9
      0, 0, 0, 0, 0, 0, 0, 0, 0
    ]);

int: total_demand = sum(s in STORES)(demand[s]); % For bounding shipment variables


% Variables
array[CENTERS] of var bool: open;                     % true if center is opened
array[CENTERS, STORES] of var int: ship_units;        % Units shipped from center c to store s
var int: total_open_cost;                             % Sum of opening costs
var int: total_ship_cost;                             % Sum of transportation costs
var int: total_cost;                                  % Objective: total cost

% Bounds / domain restrictions (kept as constraints to avoid dependent bounds)
constraint forall(c in CENTERS, s in STORES)(
  ship_units[c, s] >= 0 /\
  ship_units[c, s] <= total_demand
);


% Constraints

%--- Demand satisfaction: each store's demand must be fully met
constraint
  forall(s in STORES)(
    sum(c in CENTERS)(ship_units[c, s]) = demand[s]
  );

%--- Capacity / opening linkage: shipments out of a center cannot exceed its capacity if opened
constraint
  forall(c in CENTERS)(
    sum(s in STORES)(ship_units[c, s]) <= capacity[c] * bool2int(open[c])
  );

%--- Define total opening cost
constraint
  total_open_cost = sum(c in CENTERS)(open_cost[c] * bool2int(open[c]));

%--- Define total shipping cost
constraint
  total_ship_cost = sum(c in CENTERS, s in STORES)(ship_cost[c, s] * ship_units[c, s]);

%--- Define total cost as sum of components
constraint
  total_cost = total_open_cost + total_ship_cost;


% Objective
solve minimize total_cost;