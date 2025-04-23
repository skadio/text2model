% Parameters
int: T; % Total number of periods
array[1..T] of int: Deliver; % Demand for the product in each period
int: StorageCost; % Cost to hold one unit of product in storage for one period
int: SwitchCost; % Cost to switch the production from one period to another

% Variables
array[1..T] of var 0..sum(Deliver): Production; % Amount of product to produce each month
array[1..T] of var 0..sum(Deliver): Inventory; % Amount of product in inventory each month

% Constraints

% The inventory at the end of each month is the production of that month plus the inventory of the previous month minus the delivery of that month
constraint forall(i in 2..T) (
  Inventory[i] = Production[i] + Inventory[i-1] - Deliver[i]
);

% The inventory at the end of the first month is the production of that month minus the delivery of that month
constraint Inventory[1] = Production[1] - Deliver[1];

% The inventory at the end of the last month should be zero
constraint Inventory[T] = 0;

% The production in each month should be enough to meet the delivery of that month and the inventory of the next month
constraint forall(i in 1..T-1) (
  Production[i] >= Deliver[i] + Inventory[i+1]
);

% The production in the last month should be enough to meet the delivery of that month
constraint Production[T] >= Deliver[T];

% Objective
solve minimize sum(i in 1..T) (StorageCost * Inventory[i]) + sum(i in 2..T) (SwitchCost * abs(Production[i] - Production[i-1]));