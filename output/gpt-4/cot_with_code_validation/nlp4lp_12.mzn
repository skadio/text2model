% Parameters
int: T;
array[1..T] of int: Deliver;
int: StorageCost;
int: SwitchCost;

% Variables
array[1..T] of var 0..sum(Deliver): Production;
array[1..T] of var 0..sum(Deliver): Inventory;

% Constraints
% Initial inventory is zero
constraint Inventory[1] = Production[1] - Deliver[1];

% Inventory and production constraints for each month
constraint forall(i in 2..T) (
    Inventory[i] = Inventory[i-1] + Production[i] - Deliver[i]
);

% Inventory at the end of the year has no value
constraint Inventory[T] = 0;

% Objective
var int: TotalCost = sum(i in 1..T-1) (abs(Production[i+1] - Production[i])*SwitchCost + Inventory[i]*StorageCost);
solve minimize TotalCost;