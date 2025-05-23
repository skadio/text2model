% Parameters
int: T; % Total number of periods
array[1..T] of int: Deliver; % Demand for the product in each period
int: StorageCost; % Cost to hold one unit of product in storage for one period
int: SwitchCost; % Cost to switch the production from one period to another

% Variables
array[1..T] of var 0..sum(Deliver): Production; % Amount of product to produce in each period
array[1..T] of var 0..sum(Deliver): Inventory; % Amount of product in inventory at the end of each period

% Constraints

% The inventory at the end of each month is the production of that month plus the inventory of the previous month minus the delivery of that month
constraint forall(i in 2..T) (
  Inventory[i] = Production[i] + Inventory[i-1] - Deliver[i-1]
);

% The inventory at the end of the first month is the production of that month minus the delivery of that month
constraint Inventory[1] = Production[1] - Deliver[1];

% The inventory at the end of the last month must be zero
constraint Inventory[T] = 0;

% The production in each month must be greater than or equal to the delivery of that month
constraint forall(i in 1..T) (
  Production[i] >= Deliver[i]
);

% The production in each month must be less than or equal to the delivery of that month plus the inventory of the previous month
constraint forall(i in 2..T) (
  Production[i] <= Deliver[i] + Inventory[i-1]
);

% The production in the first month must be less than or equal to the delivery of that month
constraint Production[1] <= Deliver[1];

% The cost of switching to a new production level must be less than or equal to the switch cost times the absolute difference between the production of two consecutive months
constraint forall(i in 2..T) (
  SwitchCost * abs(Production[i] - Production[i-1]) <= SwitchCost * (Production[i] + Production[i-1])
);

% The cost of holding inventory must be less than or equal to the storage cost times the inventory of each month
constraint forall(i in 1..T-1) (
  StorageCost * Inventory[i] <= StorageCost * (Production[i] + Deliver[i])
);

% Objective
solve minimize sum(i in 1..T-1) (StorageCost * Inventory[i]) + sum(i in 2..T) (SwitchCost * abs(Production[i] - Production[i-1]));