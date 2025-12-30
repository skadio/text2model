include "globals.mzn";

int: T;                             % Total number of periods
array[1..T] of int: Deliver;       % Demand for the product in each period
int: StorageCost;                  % Cost to hold one unit of product in storage for one period
int: SwitchCost;                   % Cost to switch the production from one period to another

array[1..T] of var 0..max(Deliver): production;  % Production for each period
array[0..T] of var 0..sum(Deliver): inventory;   % Inventory at the end of each period

% Inventory constraints
constraint inventory[0] = 0;  % Start with zero inventory
constraint forall(i in 1..T)(
    inventory[i] = inventory[i-1] + production[i] - Deliver[i]
);

% Cost calculation
var int: total_cost = sum(i in 1..T)(StorageCost * inventory[i]) + 
                      sum(i in 1..T-1)(SwitchCost * abs(production[i+1] - production[i]));

% Objective: Minimize total cost
solve minimize total_cost;

% Output
output [ "Production = ", show(production), "\nInventory = ", show(inventory), "\nTotal Cost = ", show(total_cost), "\n" ];