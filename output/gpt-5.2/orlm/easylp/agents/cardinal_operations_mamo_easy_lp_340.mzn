% Parameters
% Number of routes
int: n_routes = 4;

% Index set for routes
set of int: ROUTES = 1..n_routes;

% Per-vehicle cost for each route (x1..x4)
array[ROUTES] of int: cost = [2, 3, 4, 5];

% Capacity/upper-bound constraints
int: max_x1_x2 = 100;   % x1 + x2 <= 100
int: max_x3_x4 = 200;   % x3 + x4 <= 200

% Minimum allocation constraints
int: min_x1_x3 = 50;    % x1 + x3 >= 50
int: min_x2_x4 = 150;   % x2 + x4 >= 150

% A safe explicit upper bound for each individual route variable
int: ub_route = max(max_x1_x2, max_x3_x4);

% Variables
% Vehicles allocated to each route (x[1]=x1, x[2]=x2, x[3]=x3, x[4]=x4)
array[ROUTES] of var 0..ub_route: x;

% Total operating cost
var 0..(ub_route * sum(cost)): total_cost;

% Constraints
% Link total_cost to per-route allocations and costs
constraint
  total_cost = sum(r in ROUTES)(cost[r] * x[r]);

% Capacity constraints (upper bounds on combined allocations)
constraint
  x[1] + x[2] <= max_x1_x2;  % x1 + x2 <= 100

constraint
  x[3] + x[4] <= max_x3_x4;  % x3 + x4 <= 200

% Service level constraints (minimum combined allocations)
constraint
  x[1] + x[3] >= min_x1_x3;  % x1 + x3 >= 50

constraint
  x[2] + x[4] >= min_x2_x4;  % x2 + x4 >= 150

% Objective
solve minimize total_cost;