include "globals.mzn";

%========================
% Input data (from .dzn)
%========================
int: n_suppliers;                 % number of candidate warehouses
int: n_stores;                    % number of stores
int: building_cost;               % fixed cost to open a warehouse
array[1..n_suppliers] of int: capacity;                 % capacity per warehouse
array[1..n_stores, 1..n_suppliers] of int: cost_matrix; % supply cost (store, warehouse)

%========================
% Decision variables
%========================
array[1..n_suppliers] of var 0..1: open;                % 1 if warehouse is opened
array[1..n_stores] of var 1..n_suppliers: assign;       % warehouse assigned to each store

%========================
% Constraints
%========================

% If a store is assigned to a warehouse, that warehouse must be open
constraint forall(s in 1..n_stores)(
  open[assign[s]] = 1
);

% Capacity constraints: number of stores assigned to each warehouse <= its capacity if open, else 0
constraint forall(w in 1..n_suppliers)(
  sum(s in 1..n_stores)( bool2int(assign[s] == w) ) <= capacity[w] * open[w]
);

%========================
% Objective
%========================
var int: total_building_cost = building_cost * sum(w in 1..n_suppliers)(open[w]);
var int: total_supply_cost   = sum(s in 1..n_stores)( cost_matrix[s, assign[s]] );

solve minimize total_building_cost + total_supply_cost;

%========================
% Output
%========================
output [
  "open = ", show(open), "\n",
  "assign = ", show(assign), "\n",
  "total_building_cost = ", show(total_building_cost), "\n",
  "total_supply_cost = ", show(total_supply_cost), "\n",
  "total_cost = ", show(total_building_cost + total_supply_cost), "\n"
];