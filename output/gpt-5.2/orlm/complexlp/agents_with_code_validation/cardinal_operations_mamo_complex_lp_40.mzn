% Parameters
int: nWarehouses = 6;                           % Number of warehouses
set of int: W = 1..nWarehouses;                 % Warehouse index set

array[W] of int: initial_stock =                % Current units at each warehouse
  [497, 39, 416, 71, 445, 471];

array[W] of int: required_stock =               % Required units at each warehouse
  [161, 257, 252, 251, 372, 370];

array[W, W] of int: cost =                      % Unit transportation cost from i to j
  [|  0,  5,  7,  5, 27, 49
   | 31,  0, 14, 31,  3,  4
   |  9, 13,  0, 23, 38, 19
   | 47, 34,  7,  0, 34, 35
   | 21, 11,  6,  7,  0, 50
   | 28, 41, 34, 17, 32,  0 |];

% Total supply and demand (must match for feasibility)
int: total_supply = sum(i in W)(initial_stock[i]);
int: total_demand = sum(i in W)(required_stock[i]);

% Derived bounds for shipment variables
int: max_ship = max(total_supply, total_demand); % Simple global upper bound on any shipment
int: max_unit_cost = max([cost[i,j] | i in W, j in W]);
int: max_total_cost = max_ship * max_unit_cost * nWarehouses * nWarehouses;

% Variables
array[W, W] of var 0..max_ship: ship;           % Units shipped from warehouse i to warehouse j
var 0..max_total_cost: total_cost;              % Total transportation cost

% Constraints

% Ensure total supply equals total demand for feasibility
constraint total_supply = total_demand;

% Disallow self-shipments (no shipping from a warehouse to itself)
constraint forall(i in W) ( ship[i,i] = 0 );

% Flow balance at each warehouse:
% initial_stock + inflow - outflow = required_stock
constraint
  forall(i in W) (
    initial_stock[i]
    + sum(j in W)(ship[j,i])
    - sum(j in W)(ship[i,j])
    = required_stock[i]
  );

% Define total transportation cost as the sum of (units shipped * unit cost)
constraint
  total_cost = sum(i in W, j in W)(ship[i,j] * cost[i,j]);

% Objective
solve minimize total_cost;