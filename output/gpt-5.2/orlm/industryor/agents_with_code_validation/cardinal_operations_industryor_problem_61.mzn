% Parameters
int: n_restaurants = 4;                           % number of restaurants
set of int: R = 1..n_restaurants;                 % index set for restaurants

int: A = 1;                                       % index for Restaurant A
int: B = 2;                                       % index for Restaurant B
int: C = 3;                                       % index for Restaurant C
int: D = 4;                                       % index for Restaurant D

array[R] of int: revenue = [15000, 40000, 30000, 50000];          % annual revenue ($)
array[R] of int: cost    = [1600000, 2500000, 1800000, 3000000];  % purchase cost ($)
int: budget = 6000000;                                              % total investment budget ($)

% Variables
array[R] of var 0..1: buy;                         % buy[r] = 1 if restaurant r is purchased, else 0
var 0..sum(revenue): total_revenue;                % total annual revenue from purchased restaurants
var 0..sum(cost): total_cost;                      % total cost of purchased restaurants

% Constraints

% Link total revenue to purchase decisions
constraint
  total_revenue = sum(r in R)(revenue[r] * buy[r]);

% Link total cost to purchase decisions
constraint
  total_cost = sum(r in R)(cost[r] * buy[r]);

% Budget constraint: total investment cannot exceed the available budget
constraint
  total_cost <= budget;

% Logical constraint: If Restaurant D is purchased, Restaurant A cannot be purchased
constraint
  buy[D] + buy[A] <= 1;

% Objective
solve maximize total_revenue;