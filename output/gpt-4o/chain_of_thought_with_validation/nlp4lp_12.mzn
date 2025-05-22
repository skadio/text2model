% Parameters
int: T;
array[1..T] of int: Deliver;
int: StorageCost;
int: SwitchCost;

% Derived constants
int: TotalDemand = sum(i in 1..T)(Deliver[i]);

% Variables
array[1..T] of var 0..TotalDemand: Production;
array[0..T] of var 0..TotalDemand: Inventory;

% Constraints
constraint Inventory[0] = 0;
constraint Inventory[T] = 0;

constraint
  forall(i in 1..T)(
    Inventory[i] = Inventory[i-1] + Production[i] - Deliver[i]
  );

% Objective
var int: TotalCost =
    sum(i in 1..T-1)(StorageCost * Inventory[i])
  + sum(i in 1..T-1)(SwitchCost * abs(Production[i+1] - Production[i]));

solve minimize TotalCost;