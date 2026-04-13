% Parameters
int: n_products = 3;                           % number of product types
set of int: PRODUCTS = 1..n_products;          % product index set

array[PRODUCTS] of int: labor_req = [17, 10, 2];      % labor hours required per unit
array[PRODUCTS] of int: inspect_req = [8, 4, 2];      % inspection hours required per unit
array[PRODUCTS] of int: profit = [300, 200, 100];     % profit per unit (yuan)

int: labor_available = 1000;                   % total available labor hours
int: inspect_available = 500;                  % total available inspection hours

array[PRODUCTS] of int: demand_max = [50, 80, 150];   % maximum demand per product

% Variables
array[PRODUCTS] of var 0..150: x;              % units produced for each product type
var int: total_profit;                         % total profit to maximize

% Constraints
% Demand constraints: production cannot exceed forecast maximum for each product
constraint
  forall(p in PRODUCTS) (
    x[p] <= demand_max[p]
  );

% Labor capacity constraint: total labor hours used cannot exceed availability
constraint
  sum(p in PRODUCTS) (labor_req[p] * x[p]) <= labor_available;

% Inspection capacity constraint: total inspection hours used cannot exceed availability
constraint
  sum(p in PRODUCTS) (inspect_req[p] * x[p]) <= inspect_available;

% Total profit definition: link total_profit to decision variables
constraint
  total_profit = sum(p in PRODUCTS) (profit[p] * x[p]);

% Objective
solve maximize total_profit;