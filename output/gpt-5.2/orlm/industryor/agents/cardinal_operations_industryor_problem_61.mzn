% Parameters
int: n_restaurants = 4;                         % Number of restaurants
set of int: R = 1..n_restaurants;               % Restaurant index set

array[R] of int: revenue = [15000, 40000, 30000, 50000];      % Annual revenue ($)
array[R] of int: cost    = [1600000, 2500000, 1800000, 3000000]; % Purchase cost ($)

int: budget = 6000000;                          % Total investment budget ($)

int: A = 1;                                     % Index for Restaurant A
int: B = 2;                                     % Index for Restaurant B
int: C = 3;                                     % Index for Restaurant C
int: D = 4;                                     % Index for Restaurant D

% Variables
array[R] of var 0..1: buy;                      % buy[r]=1 if restaurant r is purchased, else 0
var 0..sum(revenue): total_revenue;             % Total annual revenue from purchased restaurants
var 0..budget: total_cost;                      % Total cost of purchased restaurants

% Constraints
% Link total_cost to selected restaurants
constraint
  total_cost = sum(r in R)(cost[r] * buy[r]);

% Enforce investment budget limit
constraint
  total_cost <= budget;

% Link total_revenue to selected restaurants
constraint
  total_revenue = sum(r in R)(revenue[r] * buy[r]);

% If Restaurant D is purchased, Restaurant A cannot be purchased
constraint
  buy[D] + buy[A] <= 1;

% Objective
solve maximize total_revenue;