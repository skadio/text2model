include "globals.mzn";

int: n_suppliers;          % number of candidate warehouses
int: n_stores;             % number of stores
int: building_cost;        % cost of opening one warehouse
array[1..n_suppliers] of int: capacity;            % capacity of each warehouse
array[1..n_stores, 1..n_suppliers] of int: cost_matrix;  % supply cost per store–warehouse pair

% Decision variables
array[1..n_suppliers] of var 0..1: open;                % 1 if warehouse j is opened
array[1..n_stores] of var 1..n_suppliers: choice;       % warehouse assigned to store i

% Each store must be supplied by exactly one warehouse (choice guarantees that)

% Capacity constraints: a warehouse can serve at most its capacity
% (and must be open if it serves any store)
constraint
  forall(j in 1..n_suppliers) (
    count(choice, j) <= capacity[j] * open[j]
  );

% Costs
var int: supply_cost = sum(i in 1..n_stores)( cost_matrix[i, choice[i]] );
var int: maintenance_cost = building_cost * sum(j in 1..n_suppliers)( open[j] );
var int: total_cost = supply_cost + maintenance_cost;

% Objective
solve minimize total_cost;

% Output
output [
  "Total Cost: ", show(total_cost), "\n",
  "Open warehouses: ", show(open), "\n",
  "Assignments (store -> warehouse):\n",
  concat([ show(i) ++ " -> " ++ show(choice[i]) ++ "\n" | i in 1..n_stores ])
];